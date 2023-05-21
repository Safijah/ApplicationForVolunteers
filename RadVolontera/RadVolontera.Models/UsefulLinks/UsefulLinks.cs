using RadVolontera.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.UsefulLinks
{
    public class UsefulLinks
    {
        public long Id { get; set; }
        public string UrlLink { get; set; }
        public string Name { get; set; }
        public string AdminId { get; set; }
        public UserResponse Admin { get; set; }
    }
}
