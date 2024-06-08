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
        public string Theme { get; set; }
        public Month Month { get; set; }
    }
}
