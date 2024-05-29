using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MonitoringController : BaseCRUDController<Models.Monitoring.Monitoring, Models.Filters.MonitoringSearchObject, Models.Monitoring.MonitoringRequest, Models.Monitoring.MonitoringRequest, long>
    {
        public MonitoringController(ILogger<BaseController<Models.Monitoring.Monitoring, Models.Filters.MonitoringSearchObject, long>> logger, IMonitoringService service) : base(logger, service)
        {

        }
    }
}
