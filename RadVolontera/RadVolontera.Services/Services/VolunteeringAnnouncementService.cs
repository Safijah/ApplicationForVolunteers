using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Notification;
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
    public  class VolunteeringAnnouncementService : BaseCRUDService<Models.VolunteeringAnnouncement.VolunteeringAnnouncement, Database.VolunteeringAnnouncement, VolunteeringAnnouncementSearchObject, VolunteeringAnnouncementRequest, VolunteeringAnnouncementRequest, long>, IVolunteeringAnnouncementService
    {
        public VolunteeringAnnouncementService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Database.VolunteeringAnnouncement> AddInclude(IQueryable<Database.VolunteeringAnnouncement> query, VolunteeringAnnouncementSearchObject? search = null)
        {
            query = query.Include("AnnouncementStatus").Include("City").Include("Mentor");
            return base.AddInclude(query, search);
        }
    }
}
