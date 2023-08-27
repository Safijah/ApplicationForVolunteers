using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public class PaymentSearchObject :BaseSearchObject
    {
        public bool IncludeStudent { get; set; } = true;

        public string?  StudentId { get; set; }
        public Month ? Month { get; set; }
    }
}
