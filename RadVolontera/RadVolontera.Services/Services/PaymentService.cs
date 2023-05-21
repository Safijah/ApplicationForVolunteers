using AutoMapper;
using Microsoft.EntityFrameworkCore;
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
    public  class PaymentService : BaseCRUDService<Models.Payment.Payment, Database.Payment, PaymentSearchObject, PaymentRequest, PaymentRequest, long>, IPaymentService
    {
        public PaymentService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {
            
        }

        public override IQueryable<Database.Payment> AddInclude(IQueryable<Database.Payment> query, PaymentSearchObject? search = null)
        {
            if (search?.IncludeStudent == true)
            {
                query = query.Include("Student");
            }
            return base.AddInclude(query, search);
        }
    }
}
