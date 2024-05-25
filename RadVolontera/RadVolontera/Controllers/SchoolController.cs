using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SchoolController  : BaseCRUDController<Models.School.School, Models.Filters.BaseSearchObject, Models.School.School, Models.School.School, long>
    {
        public SchoolController(ILogger<BaseController<Models.School.School, Models.Filters.BaseSearchObject, long>> logger, ISchoolService service) : base(logger, service)
        {

        }
    }
}
