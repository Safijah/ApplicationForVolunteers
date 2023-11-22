using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public  class PaymentReportSearchObject : BaseSearchObject
    {
        public Month? Month { get; set; }
        public string? StudentId { get; set; }
        public int? Year { get; set; }
    }
}
