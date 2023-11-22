using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Models.Filters;
using RadVolontera.Services.Interfaces;
using System.Security.Claims;

namespace RadVolontera.Controllers
{
    [Route("[controller]")]
    [Authorize]
    public class BaseController<T, TSearch, TId> : ControllerBase where T : class where TSearch : class
    {
        protected readonly IService<T, TSearch, TId> _service;
        protected readonly ILogger<BaseController<T, TSearch, TId>> _logger;

        public BaseController(ILogger<BaseController<T, TSearch, TId>> logger, IService<T, TSearch, TId> service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet()]
        public async Task<PagedResult<T>> Get([FromQuery] TSearch? search = null)
        {
            return await _service.Get(search);
        }

        [HttpGet("{id}")]
        public async Task<T> GetById(TId id)
        {
            return await _service.GetById(id);
        }

        [HttpDelete("{id}")]
        public async Task Delete(TId id)
        {
             await _service.Delete(id);
        }

        public string CurrentUserIdentifier { get { return User?.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Name)?.Value; } }
        public string CurrentUserId { get { return User?.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier)?.Value; } }
        public List<string> CurrentUserRoles { get { return User?.Claims.Where(x => x.Type == ClaimTypes.Role)?.Select(x => x.Value).ToList(); } }
    }
}
