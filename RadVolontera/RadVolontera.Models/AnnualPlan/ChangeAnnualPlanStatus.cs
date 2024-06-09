using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.AnnualPlan
{
    public class ChangeAnnualPlanStatus
    {
        public long AnnualPlanId { get; set; }
        public long? StausId { get; set; }
        public string? Status { get; set; }
        public string? Reason { get; set; }
    }
}
