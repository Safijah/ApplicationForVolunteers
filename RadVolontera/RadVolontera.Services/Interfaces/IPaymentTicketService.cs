using RadVolontera.Models.Payment;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IPaymentTicketService
    {
        Task<bool> Pay(PaymentTicket vm);
    }
}
