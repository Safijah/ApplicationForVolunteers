﻿using RadVolontera.Models.Account;
using RadVolontera.Models.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IAccountService
    {
        public Task<UserResponse> Register(RegisterRequest request);
        public Task<UserResponse> Update(string userId,RegisterRequest request);
        public Task<PagedResult<UserResponse>> GetAll(UserSearchObject filter);
        public Task<AuthenticationResponse> Authenticate(string username, string password, string ipAddress);
        public DashboardData GetDashboardData();
    }
}
