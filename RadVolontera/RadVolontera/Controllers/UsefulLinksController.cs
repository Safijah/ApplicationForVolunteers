using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsefulLinksController : BaseCRUDController<Models.UsefulLinks.UsefulLinks, Models.Filters.UsefulLinksSearchObject, Models.UsefulLinks.UsefulLinksRequest, Models.UsefulLinks.UsefulLinksRequest, long>
    {
        public UsefulLinksController(ILogger<BaseController<Models.UsefulLinks.UsefulLinks, Models.Filters.UsefulLinksSearchObject, long>> logger, IUsefulLinksService service) : base(logger, service)
        {

        }
    }
}
