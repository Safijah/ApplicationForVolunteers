using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Models.Report;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReportController : BaseCRUDController<Models.Report.Report, Models.Filters.ReportSearchObject, Models.Report.ReportRequest, Models.Report.ReportRequest, long>
    {
        public ReportController(ILogger<BaseController<Models.Report.Report, Models.Filters.ReportSearchObject, long>> logger, IReportService service) : base(logger, service)
        {

        }

        [HttpPut("change-status")]
        public virtual async Task<RadVolontera.Models.Report.Report> ChangeStatus([FromBody] ChangeReportStatusRequest request)
        {
            var result = await (_service as IReportService).ChangeReportStatus(request);
            return result;
        }
    }
}
