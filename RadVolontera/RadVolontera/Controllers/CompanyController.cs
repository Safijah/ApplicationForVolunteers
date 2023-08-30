using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyController : BaseCRUDController<Models.Company.Company, Models.Filters.CompanySearchObject, Models.Company.CompanyRequest, Models.Company.CompanyRequest, long>
    {
        public CompanyController(ILogger<BaseController<Models.Company.Company, Models.Filters.CompanySearchObject, long>> logger, ICompanyService service) : base(logger, service)
        {

        }
    }
}
