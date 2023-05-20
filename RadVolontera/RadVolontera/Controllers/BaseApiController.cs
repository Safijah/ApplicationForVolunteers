using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace RadVolontera.Controllers
{
    [ApiController]
    public abstract class BaseApiController : ControllerBase
    {
        private readonly IServiceProvider _provider;

        public BaseApiController(IServiceProvider provider)
        {
            _provider = provider;
        }

        public string CurrentUserIdentifier { get { return User?.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Name)?.Value; } }
        public string CurrentUserId { get { return User?.Claims.FirstOrDefault(x => x.Type == ClaimTypes.NameIdentifier)?.Value; } }
        public List<string> CurrentUserRoles { get { return User?.Claims.Where(x => x.Type == ClaimTypes.Role)?.Select(x => x.Value).ToList(); } }

        internal T GetService<T>()
        {
            using var scope = _provider.CreateScope();
            return scope.ServiceProvider.GetService<T>();
        }
    }
}
