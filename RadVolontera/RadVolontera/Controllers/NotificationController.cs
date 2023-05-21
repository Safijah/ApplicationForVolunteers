using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : BaseCRUDController<Models.Notification.Notification, Models.Filters.NotificationSearchObject, Models.Notification.NotificationRequest, Models.Notification.NotificationRequest, long>
    {
        public NotificationController(ILogger<BaseController<Models.Notification.Notification, Models.Filters.NotificationSearchObject, long>> logger, INotificationService service) : base(logger, service)
        {

        }
    }
}
