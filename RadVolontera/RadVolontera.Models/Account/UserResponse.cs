﻿using RadVolontera.Models.Enums;
using RadVolontera.Models.Token;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Account
{
    public  class UserResponse
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? BirthDate { get; set; }
        public Gender Gender { get; set; }
        public UserTypes UserType { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string UserName { get; set; }
        public string Role { get; set; }
        public List<string> Roles { get; set; }
        public string FullName { get { return $"{FirstName ?? ""} {LastName ?? ""}"; } }
        public bool IsUser { get; set; }
        public TokenInfo Token { get; internal set; }
        public bool EmailConfirmed { get; set; }
    }
}
