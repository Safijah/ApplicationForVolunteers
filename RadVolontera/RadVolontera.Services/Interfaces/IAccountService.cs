using RadVolontera.Models.Account;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IAccountService : ICRUDService<Models.Account.UserResponse, BaseSearchObject, Models.Account.UserResponse, Models.Account.UserResponse, string>
    {
        public Task<UserResponse> Register(RegisterRequest request);
        public Task<UserResponse> Update(string userId,RegisterRequest request);
        public Task<PagedResult<UserResponse>> GetAll(UserSearchObject filter);
        public Task<AuthenticationResponse> Authenticate(string username, string password, string ipAddress);
        public DashboardData GetDashboardData();
        public Task<UserResponse> UpdateProfile(string userId, UserUpdateRequest request);
        public Task<UserResponse> UserProfile(string userId);
        public Task ChangePassword(string userId, ChangePasswordRequest request);
        public Task<PagedResult<UserResponse>> GetStudentsForMentor(string mentorId);
    }
}
