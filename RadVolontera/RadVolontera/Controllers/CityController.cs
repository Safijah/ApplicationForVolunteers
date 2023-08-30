using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CityController : BaseCRUDController<Models.City.City, Models.Filters.BaseSearchObject, Models.City.City, Models.City.City, long>
    {
        public CityController(ILogger<BaseController<Models.City.City, Models.Filters.BaseSearchObject, long>> logger, ICityService service) : base(logger, service)
        {

        }
    }
}
