using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public class MonitoringSearchObject : BaseSearchObject
    {
        public string? MentorId { get; set; }
        public bool? ForToday { get; set; } = false;
    }
}
