using RadVolontera.Models.Enums;
using RadVolontera.Models.MonthlyPlan;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.MonthlyPlanTemplate
{
    public class MonthlyPlanTemplateRequest
    {
        public string Theme { get; set; }
        public Month Month { get; set; }
    }
}
