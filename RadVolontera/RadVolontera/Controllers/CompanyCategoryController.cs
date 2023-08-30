using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]

    public class CompanyCategoryController : BaseCRUDController<Models.CompanyCategory.CompanyCategory, Models.Filters.CompanyCategorySearcObject, Models.CompanyCategory.CompanyCategoryRequest, Models.CompanyCategory.CompanyCategoryRequest, long>
    {
        public CompanyCategoryController(ILogger<BaseController<Models.CompanyCategory.CompanyCategory, Models.Filters.CompanyCategorySearcObject, long>> logger, ICompanyCategoryService service) : base(logger, service)
        {

        }
    }
}
