using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.CompanyEvent
{
    public class RegisterForEventRequest
    {
        public string MentorId { get; set; }
        public long CompanyEventId { get; set; }
    }
}
