using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VolunteeringAnnouncementController : BaseCRUDController<Models.VolunteeringAnnouncement.VolunteeringAnnouncement, Models.Filters.VolunteeringAnnouncementSearchObject, Models.VolunteeringAnnouncement.VolunteeringAnnouncementRequest, Models.VolunteeringAnnouncement.VolunteeringAnnouncementRequest, long>
    {
        public VolunteeringAnnouncementController(ILogger<BaseController<Models.VolunteeringAnnouncement.VolunteeringAnnouncement, Models.Filters.VolunteeringAnnouncementSearchObject, long>> logger, IVolunteeringAnnouncementService service) : base(logger, service)
        {

        }
    }
}
