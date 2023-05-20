using AutoMapper;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Payment;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public  class PaymentService : BaseCRUDService<Models.Payment.Payment, Database.Payment, PaymentSearchObject, PaymentRequest, PaymentRequest>, IPaymentService
    {
        public PaymentService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
            
        }
    }
}
