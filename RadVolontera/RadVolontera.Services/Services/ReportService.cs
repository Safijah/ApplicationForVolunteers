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
            if (insert.PresentStudentsIds  != null && insert.PresentStudentsIds.Any())
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

        public async Task<RadVolontera.Models.Report.Report> ChangeReportStatus(ChangeReportStatusRequest request)
        {
            var value = await _context.Reports
                .Include(r=>r.VolunteeringAnnouncement)
                .ThenInclude(r=>r.Mentor)
                .FirstOrDefaultAsync(v => v.Id == request.ReportId);

            if (value == null)
                throw new ApiException("Not found", System.Net.HttpStatusCode.BadRequest);

            var status =await _context.Statuses.FirstOrDefaultAsync(s => s.Name == request.Status);

            if (status == null)
                throw new ApiException("Status not found", System.Net.HttpStatusCode.BadRequest);

            if (status.Name == "Approved")
            {
                await _emailService.SendEmailAsync(value.VolunteeringAnnouncement.Mentor.Email, "Izvještaj", $"<h1>Zdravo {value.VolunteeringAnnouncement.Mentor.FirstName}</h1>" +
                   $"<p>Poštovani/a, vaš izvještaj je prihvaćen</p>");
            }
            else if (status.Name == "Rejected")
            {
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
                .Include(u => u.Mentor)
                .Where(v => v.MentorId == studentId).ToListAsync();

            if (value == null)
                throw new ApiException("Not found", System.Net.HttpStatusCode.BadRequest);


            var tmp = _mapper.Map<List<Models.Report.Report>>(value);
            result.Result = tmp;
            return result;
        }
    }
}
