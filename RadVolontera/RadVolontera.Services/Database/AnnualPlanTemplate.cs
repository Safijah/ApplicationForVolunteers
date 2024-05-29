using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class AnnualPlanTemplate : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public int Year { get; set; }
        public ICollection<MonthlyPlanTemplate> MonthlyPlanTemplates { get; set; }
        public ICollection<AnnualPlan> AnnualPlans { get; set; }
    }
}
