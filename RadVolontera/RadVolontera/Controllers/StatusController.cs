using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class StatusController : BaseCRUDController<Models.Status.Status, Models.Filters.BaseSearchObject, Models.Status.Status, Models.Status.Status, long>
    {
        public StatusController(ILogger<BaseController<Models.Status.Status, Models.Filters.BaseSearchObject, long>> logger, IStatusService service) : base(logger, service)
        {

        }
    }
}
