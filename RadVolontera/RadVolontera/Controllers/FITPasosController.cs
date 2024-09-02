using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FITPasosController : BaseCRUDController<Models.FITPasos.FITPasos, Models.Filters.FITPasosSearchObject, Models.FITPasos.FITPasosRequest, Models.FITPasos.FITPasosRequest, long>
    {
        public FITPasosController(ILogger<BaseController<Models.FITPasos.FITPasos, Models.Filters.FITPasosSearchObject, long>> logger, IFITPasosService service) : base(logger, service)
        {

        }
    }
}
