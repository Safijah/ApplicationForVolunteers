using RadVolontera.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Notification
{
    public  class Notification
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content { get; set; }
        public long SectionId { get; set; }
        public Section.Section Section { get; set; }
        public string AdminId { get; set; }
        public UserResponse Admin { get; set; }
    }
}
