using RadVolontera.Models.Account;
using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Payment
{
    public  class Payment
    {
        public long Id { get; set; }
        public string Notes { get; set; }
        public double Amount { get; set; }
        public Month Month { get; set; }
        public string MonthName { get; set; }
        public int Year { get; set; }
        public string StudentId { get; set; }
        public UserResponse Student { get; set; }
    }
}
