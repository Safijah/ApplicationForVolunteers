using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public class CompanyEventSearchObject : BaseSearchObject
    {
        public long? CompanyId { get; set; }
        public string? MentorId { get; set; }
        public bool Registered { get; set; }
    }
}
