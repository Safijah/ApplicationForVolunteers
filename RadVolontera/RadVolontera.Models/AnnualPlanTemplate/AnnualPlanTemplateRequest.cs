using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.AnnualPlanTemplate
{
    public class AnnualPlanTemplateRequest
    {
        public int Year { get; set; }
        public List<MonthlyPlanTemplate.MonthlyPlanTemplateRequest> MonthlyPlanTemplates { get; set; }
    }
}
