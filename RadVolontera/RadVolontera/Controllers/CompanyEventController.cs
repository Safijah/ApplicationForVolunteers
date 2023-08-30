using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyEventController : BaseCRUDController<Models.CompanyEvent.CompanyEvent, Models.Filters.CompanyEventSearchObject, Models.CompanyEvent.CompanyEventRequest, Models.CompanyEvent.CompanyEventRequest, long>
    {
        public CompanyEventController(ILogger<BaseController<Models.CompanyEvent.CompanyEvent, Models.Filters.CompanyEventSearchObject, long>> logger, ICompanyEventService service) : base(logger, service)
        {

        }
    }
}
