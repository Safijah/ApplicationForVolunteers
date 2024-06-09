using RadVolontera.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.AnnualPlan
{
    public class AnnualPlan
    {
        public long Id { get; set; }
        public int Year { get; set; }
        public long AnnualPlanTemplateId { get; set; }
        public string MentorId { get; set; }
        public string? Reason { get; set; }
        public long StatusId { get; set; }
        public UserResponse Mentor { get; set; }
        public List<MonthlyPlan.MonthlyPlan> MonthlyPlans { get; set; }
    }
}
