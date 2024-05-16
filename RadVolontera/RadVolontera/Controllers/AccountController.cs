
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Models.Account;
using RadVolontera.Models.Enums;
using RadVolontera.Models.Filters;
using RadVolontera.Services.Interfaces;


namespace RadVolontera.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class AccountController : ControllerBase
    {
        private readonly IAccountService _accountService;

        public AccountController(IAccountService accountService, IServiceProvider provider)
        {
            _accountService = accountService;
        }


        [HttpPost("register")]
        public async Task<ActionResult<UserResponse>> Register([FromBody] RegisterRequest request)
        {
            var userResponse = await _accountService.Register(new RegisterRequest
            {
                UserName = request.UserName,
                Password = request.Password,
                Email = request.Email,
                FirstName = request.FirstName,
                LastName = request.LastName,
                Gender = request.Gender,
                PhoneNumber = request.PhoneNumber,
                BirthDate = request.BirthDate,
                UserType = request.UserType,

            });

            return Ok(userResponse);
        }

        [AllowAnonymous]
        [HttpPost("authenticate")]
        [Consumes("application/json")]
        public async Task<ActionResult<AuthenticationResponse>> Authenticate([FromBody] AuthenticationRequest request)
        {
            return Ok(await _accountService.Authenticate(request.Username, request.Password, string.Empty));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpPut("{userId}")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> Update([FromRoute] string userId, [FromBody] RegisterRequest request)
        {
            return Ok(await _accountService.Update(userId, request));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet]
        [Consumes("application/json")]
        public async Task<ActionResult<PagedResult<UserResponse>>> GetAll([FromQuery] UserSearchObject filter)
        {
            return Ok(await _accountService.GetAll(filter));
        }

        [Authorize(Roles = Roles.Admin)]
        [HttpGet("dashboard-data")]
        [Consumes("application/json")]
        public ActionResult<PagedResult<UserResponse>> GetDashboardData()
        {
            return Ok(_accountService.GetDashboardData());
        }


        [HttpPut("update-profile/{userId}")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> UpdateProfile([FromRoute] string userId, [FromBody] UserUpdateRequest request)
        {
            return Ok(await _accountService.UpdateProfile(userId, request));
        }

        [HttpGet("user-profile/{userId}")]
        [Consumes("application/json")]
        public async Task<ActionResult<UserResponse>> UserProfile([FromRoute] string userId)
        {
            return Ok(await _accountService.UserProfile(userId));
        }

        [HttpPost("change-password/{userId}")]
        public async Task<ActionResult> ChangePassword([FromRoute] string userId,ChangePasswordRequest request)
        {

            await _accountService.ChangePassword(userId, request);
            return Ok();
        }
    }
}
