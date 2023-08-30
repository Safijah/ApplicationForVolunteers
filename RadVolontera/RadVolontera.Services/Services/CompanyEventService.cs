using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.CompanyEvent;
using RadVolontera.Models.Filters;
using RadVolontera.Models.UsefulLinks;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class CompanyEventService : BaseCRUDService<Models.CompanyEvent.CompanyEvent, Database.CompanyEvent, CompanyEventSearchObject, Models.CompanyEvent.CompanyEventRequest, Models.CompanyEvent.CompanyEventRequest, long>, ICompanyEventService
    {

        public CompanyEventService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.CompanyEvent> AddFilter(IQueryable<Database.CompanyEvent> query, CompanyEventSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.CompanyId != null)
                filteredQuery = filteredQuery.Where(x => x.CompanyId==search.CompanyId);

            return filteredQuery;
        }

        public override IQueryable<Database.CompanyEvent> AddInclude(IQueryable<Database.CompanyEvent> query, CompanyEventSearchObject? search = null)
        {
            query = query.Include("Company");
            return base.AddInclude(query, search);
        }
    }
}
