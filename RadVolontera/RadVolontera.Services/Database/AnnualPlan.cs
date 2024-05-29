using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class AnnualPlan : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public int Year { get; set; }
        public long AnnualPlanTemplateId { get; set; }
        public AnnualPlanTemplate AnnualPlanTemplate { get; set; }
        public ICollection<MonthlyPlan> MonthlyPlans { get; set; }
    }
}
