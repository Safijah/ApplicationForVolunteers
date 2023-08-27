using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public  class ReportSearchObject : BaseSearchObject
    {
        public string ? Name { get; set; }
        public long? StatusId { get; set; }
        public string ? MentorId { get; set; }
    }
}
