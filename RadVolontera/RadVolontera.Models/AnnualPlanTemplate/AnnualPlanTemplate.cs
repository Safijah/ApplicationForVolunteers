using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.AnnualPlanTemplate
{
    public class AnnualPlanTemplate
    {
        public long Id { get; set; }
        public int Year { get; set; }
        public List<MonthlyPlanTemplate.MonthlyPlanTemplate> MonthlyPlanTemplates { get; set; }
    }
}
