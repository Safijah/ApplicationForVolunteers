using RadVolontera.Models.Filters;
using RadVolontera.Models.Payment;
using RadVolontera.Models.VolunteeringAnnouncement;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public  interface IVolunteeringAnnouncementService : ICRUDService<Models.VolunteeringAnnouncement.VolunteeringAnnouncement, VolunteeringAnnouncementSearchObject, VolunteeringAnnouncementRequest, VolunteeringAnnouncementRequest, long>
    {
    }
}
