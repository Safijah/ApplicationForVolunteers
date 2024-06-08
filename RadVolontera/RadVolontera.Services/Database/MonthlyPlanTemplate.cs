using RadVolontera.Models.Enums;
using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class MonthlyPlanTemplate : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Theme { get; set; }
        public Month Month { get; set; }
        public long AnnualPlanTemplateId { get; set; }
        public AnnualPlanTemplate AnnualPlanTemplate { get; set; }
    }
}
