using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Notification;
using RadVolontera.Models.Shared;
using RadVolontera.Models.VolunteeringAnnouncement;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class VolunteeringAnnouncementService : BaseCRUDService<Models.VolunteeringAnnouncement.VolunteeringAnnouncement, Database.VolunteeringAnnouncement, VolunteeringAnnouncementSearchObject, VolunteeringAnnouncementRequest, VolunteeringAnnouncementRequest, long>, IVolunteeringAnnouncementService
    {
        private readonly IEmailService _emailService;
        public VolunteeringAnnouncementService(AppDbContext context, IMapper mapper, IEmailService emailService) : base(context, mapper)
        {
            _emailService = emailService;
        }
        public override IQueryable<Database.VolunteeringAnnouncement> AddInclude(IQueryable<Database.VolunteeringAnnouncement> query, VolunteeringAnnouncementSearchObject? search = null)
        {
            query = query.Include("AnnouncementStatus").Include("City").Include("Mentor").Include("Report");
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.VolunteeringAnnouncement> AddFilter(IQueryable<Database.VolunteeringAnnouncement> query, VolunteeringAnnouncementSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.MentorId))
            {
                filteredQuery = filteredQuery.Where(x => x.MentorId == search.MentorId);
            }

            if (search?.StatusId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.AnnouncementStatusId == search.StatusId);
            }

            return filteredQuery;
        }

        public override async Task BeforeInsert(Database.VolunteeringAnnouncement entity, Models.VolunteeringAnnouncement.VolunteeringAnnouncementRequest insert)
        {
            var status = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "On hold");
            if (status != null)
            {
                entity.AnnouncementStatusId = status.Id;
            }
        }

        public override async Task BeforeUpdate(Database.VolunteeringAnnouncement entity, Models.VolunteeringAnnouncement.VolunteeringAnnouncementRequest update)
        {
            var currentStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Id == entity.AnnouncementStatusId);
            var onHoldStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "On hold");
            if (currentStatus != null && currentStatus.Name == "Rejected")
            {
                update.AnnouncementStatusId = onHoldStatus?.Id ?? entity.AnnouncementStatusId;
            }
            else
            {
                update.AnnouncementStatusId = entity.AnnouncementStatusId;
            }
        }

        public async Task<RadVolontera.Models.VolunteeringAnnouncement.VolunteeringAnnouncement> ChangeVolunteeringAnnouncementStatus(ChangeStatusRequest request)
        {
            var value = await _context.VolunteeringAnnouncements
                .Include(u => u.Mentor)
                .FirstOrDefaultAsync(v => v.Id == request.VolunteeringAnnouncementId);

            if (value == null)
                throw new ApiException("Not found", System.Net.HttpStatusCode.BadRequest);

            var status = _context.Statuses.FirstOrDefault(s => s.Name == request.Status);

            if (status == null)
                throw new ApiException("Status not found", System.Net.HttpStatusCode.BadRequest);

            value.AnnouncementStatusId = status.Id;

            if (status.Name == "Approved")
            {
                await _emailService.SendEmailAsync(value.Mentor.Email, "Najava", $"<h1>Zdravo {value.Mentor.FirstName}</h1>" +
                   $"<p>Poštovani/a, vaša najava je prihvaćena</p>");
            }
            else if (status.Name == "Rejected")
            {
                value.Reason = request.Reason;
                await _emailService.SendEmailAsync(value.Mentor.Email, "Najava", $"<h1>Zdravo {value.Mentor.FirstName}</h1>" +
               $"<p>Poštovani/a, vaša najava je vraćena. Molimo Vas da je ispravite u što kraćem roku</p></br><p>{request.Notes}</p>");
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<RadVolontera.Models.VolunteeringAnnouncement.VolunteeringAnnouncement>(value);
        }

        public async Task<PagedResult<Models.VolunteeringAnnouncement.VolunteeringAnnouncement>> MentorAnnouncements(string studentId)
        {
            var result = new PagedResult<Models.VolunteeringAnnouncement.VolunteeringAnnouncement>();
            var value = await _context.VolunteeringAnnouncements
                .Include(a => a.AnnouncementStatus)
                .Include(u => u.Mentor)
                .Include(r=>r.Report)
                .Where(v => v.MentorId == studentId).ToListAsync();

            if (value == null)
                throw new ApiException("Not found", System.Net.HttpStatusCode.BadRequest);

            var tmp = _mapper.Map<List<Models.VolunteeringAnnouncement.VolunteeringAnnouncement>>(value);
            result.Result = tmp;
            return result;
        }
    }
}
