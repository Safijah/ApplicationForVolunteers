using RadVolontera.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Monitoring
{
    public  class Monitoring
    {
        public long Id { get; set; }
        public string Notes { get; set; }
        public string MentorId { get; set; }
        public UserResponse Mentor { get; set; }
        public DateTime Date { get; set; }
        public string Url { get; set; }
    }
}
