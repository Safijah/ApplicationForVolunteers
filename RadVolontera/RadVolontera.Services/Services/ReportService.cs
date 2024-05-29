using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Report;
using RadVolontera.Models.Shared;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class ReportService : BaseCRUDService<Models.Report.Report, Database.Report, ReportSearchObject, ReportRequest, ReportRequest, long>, IReportService
    {
        private readonly IEmailService _emailService;
        public ReportService(AppDbContext context, IMapper mapper, IEmailService emailService) : base(context, mapper)
        {
            _emailService = emailService;
        }

        public override IQueryable<Database.Report> AddInclude(IQueryable<Database.Report> query, ReportSearchObject? search = null)
        {
            query = query.Include("Status")
                .Include("VolunteeringAnnouncement")
                .Include("PresentStudents")
                .Include("AbsentStudents")
                .Include("Mentor");
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.Report> AddFilter(IQueryable<Database.Report> query, ReportSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.MentorId))
            {
                filteredQuery = filteredQuery.Where(x => x.MentorId == search.MentorId);
            }

            if (search?.StatusId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.StatusId == search.StatusId);
            }

            return filteredQuery;
        }

        public override async Task BeforeInsert(Database.Report entity, Models.Report.ReportRequest insert)
        {
            if (insert.PresentStudentsIds != null && insert.PresentStudentsIds.Any())
            {
                var presentStudents = _context.Users.Select(u => u).Where(u => insert.PresentStudentsIds.Contains(u.Id)).ToList();
                entity.PresentStudents = presentStudents;
            }

            if (insert.AbsentStudentsIds != null && insert.AbsentStudentsIds.Any())
            {
                var absentStudents = _context.Users.Select(u => u).Where(u => insert.AbsentStudentsIds.Contains(u.Id)).ToList();
                entity.AbsentStudents = absentStudents;
            }

            var status = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "On hold");

            if (status != null)
            {
                entity.StatusId = status.Id;
            }
        }

        public override async Task BeforeUpdate(Database.Report entity, Models.Report.ReportRequest update)
        {
            var currentStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Id == entity.StatusId);
            var onHoldStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "On hold");
            if (currentStatus != null && currentStatus.Name == "Rejected")
            {
                update.StatusId = onHoldStatus?.Id ?? entity.StatusId;
            }
            else
            {
                update.StatusId = entity.StatusId;
            }

           await this.ManageStudents(entity.Id, update);

            update.VolunteeringAnnouncementId = entity.VolunteeringAnnouncementId;
        }

        public async Task<RadVolontera.Models.Report.Report> ChangeReportStatus(ChangeReportStatusRequest request)
        {
            var value = await _context.Reports
                .Include(r => r.VolunteeringAnnouncement)
                .ThenInclude(r => r.Mentor)
                .FirstOrDefaultAsync(v => v.Id == request.ReportId);

            if (value == null)
                throw new ApiException("Not found", System.Net.HttpStatusCode.BadRequest);

            var status = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == request.Status);

            if (status == null)
                throw new ApiException("Status not found", System.Net.HttpStatusCode.BadRequest);

            if (status.Name == "Approved")
            {
                await _emailService.SendEmailAsync(value.VolunteeringAnnouncement.Mentor.Email, "Izvještaj", $"<h1>Zdravo {value.VolunteeringAnnouncement.Mentor.FirstName}</h1>" +
                   $"<p>Poštovani/a, vaš izvještaj je prihvaćen</p>");
            }
            else if (status.Name == "Rejected")
            {
                value.Reason = request.Reason;
                await _emailService.SendEmailAsync(value.VolunteeringAnnouncement.Mentor.Email, "Izvještaj", $"<h1>Zdravo {value.VolunteeringAnnouncement.Mentor.FirstName}</h1>" +
               $"<p>Poštovani/a, vaš izvještaj je vraćen. Molimo Vas da ga ispravite u što kraćem roku</p></br><p>{request.Notes}</p>");
            }

            value.StatusId = status.Id;

            await _context.SaveChangesAsync();
            return _mapper.Map<RadVolontera.Models.Report.Report>(value);
        }

        public async Task<PagedResult<Models.Report.Report>> MentorReports(string studentId)
        {
            var result = new PagedResult<Models.Report.Report>();
            var value = await _context.Reports
                .Include(r => r.Status)
                .Include(u => u.Mentor)
                .Include(s => s.AbsentStudents)
                .Include(s => s.PresentStudents)
                .Where(v => v.MentorId == studentId).ToListAsync();

            if (value == null)
                throw new ApiException("Not found", System.Net.HttpStatusCode.BadRequest);


            var tmp = _mapper.Map<List<Models.Report.Report>>(value);
            result.Result = tmp;
            return result;
        }

        private async Task ManageStudents(long reportId, Models.Report.ReportRequest update)
        {
            var entity = await _context.Reports
                .Include(r => r.AbsentStudents)
                .Include(r => r.PresentStudents)
                .FirstOrDefaultAsync(r=>r.Id==reportId);

            var absentStudentsToRemove = entity.AbsentStudents
            .Where(i => !update.AbsentStudentsIds.Any(s => s == i.Id)).ToList();

            if (absentStudentsToRemove.Any())
            {
                absentStudentsToRemove.ForEach(student =>
                {
                    entity.AbsentStudents.Remove(student);
                });
            }

            var absentStudentsToAdd = update.AbsentStudentsIds.Where(i => !entity.AbsentStudents.Any(s => s.Id == i));

            if (absentStudentsToAdd.Any())
            {
                var absentStudents = _context.Users.Select(u => u).Where(u => absentStudentsToAdd.Contains(u.Id)).ToList();
                foreach(var student in absentStudents)
                {
                    entity.AbsentStudents.Add(student);
                }
            }

            var presenttudentsToRemove = entity.PresentStudents
            .Where(i => !update.PresentStudentsIds.Any(s => s == i.Id)).ToList();

            if (presenttudentsToRemove.Any())
            {
                presenttudentsToRemove.ForEach(student =>
                {
                    entity.PresentStudents.Remove(student);
                });
            }

            var presentStudentsToAdd = update.PresentStudentsIds.Where(i => !entity.PresentStudents.Any(s => s.Id == i));

            if (presentStudentsToAdd.Any())
            {
                var presentStudents = _context.Users.Select(u => u).Where(u => presentStudentsToAdd.Contains(u.Id)).ToList();
                foreach(var student in presentStudents) { 
                        entity.PresentStudents.Add(student);
                }
            }

        }
    }
}
