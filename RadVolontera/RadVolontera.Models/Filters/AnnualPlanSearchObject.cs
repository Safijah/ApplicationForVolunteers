using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public class AnnualPlanSearchObject : BaseSearchObject
    {
        public int ? Year { get; set; }
        public string? MentorId { get; set; }
        public long? StatusId { get; set; }
    }
}
