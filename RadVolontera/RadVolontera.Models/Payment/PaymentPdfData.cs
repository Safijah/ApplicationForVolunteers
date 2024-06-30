using RadVolontera.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Payment
{
    public class PaymentPdfData
    {
        public List<Payment> Payments { get; set; }
        public UserResponse Student { get; set; }
    }
}
