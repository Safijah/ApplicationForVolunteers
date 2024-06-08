using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Models.Filters;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnnualPlanTemplateController : BaseCRUDController<Models.AnnualPlanTemplate.AnnualPlanTemplate, Models.Filters.AnnualPlanTemplateSearchObject, Models.AnnualPlanTemplate.AnnualPlanTemplateRequest, Models.AnnualPlanTemplate.AnnualPlanTemplateRequest, long>
    {
        public AnnualPlanTemplateController(ILogger<BaseController<Models.AnnualPlanTemplate.AnnualPlanTemplate, Models.Filters.AnnualPlanTemplateSearchObject, long>> logger, IAnnualTemplateService service) : base(logger, service)
        {

        }

        [HttpGet("available-years")]
        public virtual async Task<List<int>> StudentAnnouncements()
        {
            var result = await (_service as IAnnualTemplateService).AvailableYears();
            return result;
        }
    }
}
