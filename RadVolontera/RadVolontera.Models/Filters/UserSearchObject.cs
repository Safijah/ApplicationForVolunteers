using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public class UserSearchObject
    {
        public string? FullName { get; set; }
        public UserTypes? UserTypes { get; set; }
    }
}
