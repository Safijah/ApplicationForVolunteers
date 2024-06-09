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
        public string ? Reason { get; set; }
        public long AnnualPlanTemplateId { get; set; }
        public AnnualPlanTemplate AnnualPlanTemplate { get; set; }
        public string MentorId { get; set; }
        public User Mentor { get; set; }
        public long StatusId { get; set; }
        public Status Status { get; set; }
        public ICollection<MonthlyPlan> MonthlyPlans { get; set; }
    }
}
