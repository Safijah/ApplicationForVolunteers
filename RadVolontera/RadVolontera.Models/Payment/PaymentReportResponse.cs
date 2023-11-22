using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Payment
{
    public class PaymentReportResponse
    {
        public Month Month { get; set; }
        public string MonthName { get; set; }
        public double Amount { get; set; }
    }
}
