using RadVolontera.Models.Filters;
using RadVolontera.Models.Payment;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public  interface IPaymentService : ICRUDService<Models.Payment.Payment, PaymentSearchObject, PaymentRequest, PaymentRequest>
    {
    }
}
