using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.MonthlyPlanTemplate
{
    public class MonthlyPlanTemplate
    {
        public long Id { get; set; }
        public string Theme { get; set; }
        public Month Month { get; set; }
    }
}
