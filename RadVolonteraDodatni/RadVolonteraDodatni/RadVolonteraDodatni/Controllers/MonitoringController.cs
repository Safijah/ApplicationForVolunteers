using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolonteraDodatni.Dtos.Monitoring;
using RadVolonteraDodatni.Services;

namespace RadVolonteraDodatni.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MonitoringController : ControllerBase
    {
        private IMonitoringService _monitoringService;
        public MonitoringController(IMonitoringService monitoringService)
        {
            _monitoringService = monitoringService;
        }

        [HttpGet]
        public virtual async Task<List<Dtos.Monitoring.Monitoring>> Get([FromQuery] MonitoringSearchObject monitoringSearch)
        {
            var result = await _monitoringService.Get(monitoringSearch);
            return result;
        }
    }
}
