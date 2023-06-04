using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Models.VolunteeringAnnouncement;
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

        [HttpPut("change-status")]
        public virtual async Task<RadVolontera.Models.VolunteeringAnnouncement.VolunteeringAnnouncement> ChangeStatus([FromBody] ChangeStatusRequest request)
        {
            var result = await (_service as IVolunteeringAnnouncementService).ChangeVolunteeringAnnouncementStatus(request);
            return result;
        }
    }
}
