using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.MonthlyPlan
{
    public class MonthlyPlanRequest
    {
        public Month Month { get; set; }
        public string Theme1 { get; set; }
        public string Theme2 { get; set; }
        public string Goals1 { get; set; }
        public string Goals2 { get; set; }
    }
}
