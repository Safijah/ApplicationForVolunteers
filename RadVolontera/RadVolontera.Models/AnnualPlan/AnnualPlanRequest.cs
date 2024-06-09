using RadVolontera.Models.MonthlyPlan;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.AnnualPlan
{
    public class AnnualPlanRequest
    {
        public int Year { get; set; }
        public string MentorId { get; set; }
        public long? StatusId { get; set; }
        public long? AnnualPlanTemplateId { get; set; }
        public List<MonthlyPlanRequest> MonthlyPlans { get; set; }
    }
}
