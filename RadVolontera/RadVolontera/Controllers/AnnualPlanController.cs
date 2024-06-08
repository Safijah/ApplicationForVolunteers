using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnnualPlanController : BaseCRUDController<Models.AnnualPlan.AnnualPlan, Models.Filters.AnnualPlanSearchObject, Models.AnnualPlan.AnnualPlanRequest, Models.AnnualPlan.AnnualPlanRequest, long>
    {
        public AnnualPlanController(ILogger<BaseController<Models.AnnualPlan.AnnualPlan, Models.Filters.AnnualPlanSearchObject, long>> logger, IAnnualPlanService service) : base(logger, service)
        {

        }
    }
}
