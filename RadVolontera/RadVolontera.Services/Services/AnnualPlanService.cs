using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.AnnualPlan;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Notification;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
   
    public class AnnualPlanService : BaseCRUDService<Models.AnnualPlan.AnnualPlan, Database.AnnualPlan, AnnualPlanSearchObject, AnnualPlanRequest, AnnualPlanRequest, long>, IAnnualPlanService
    {
        public AnnualPlanService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.AnnualPlan> AddFilter(IQueryable<Database.AnnualPlan> query, AnnualPlanSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            return filteredQuery;
        }

        public override IQueryable<Database.AnnualPlan> AddInclude(IQueryable<Database.AnnualPlan> query, AnnualPlanSearchObject? search = null)
        {
            query = query.Include("Section").Include("Admin");
            return base.AddInclude(query, search);
        }
    }
}


