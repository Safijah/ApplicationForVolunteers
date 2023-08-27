using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Payment;
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
    public  class UsefulLinksService : BaseCRUDService<Models.UsefulLinks.UsefulLinks, Database.UsefulLinks, UsefulLinksSearchObject, UsefulLinksRequest, UsefulLinksRequest, long>, IUsefulLinksService
    {

        public UsefulLinksService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.UsefulLinks> AddFilter(IQueryable<Database.UsefulLinks> query, UsefulLinksSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.Name));
            }

            return filteredQuery;
        }

        public override IQueryable<Database.UsefulLinks> AddInclude(IQueryable<Database.UsefulLinks> query, UsefulLinksSearchObject? search = null)
        {
            query = query.Include("Admin");
            return base.AddInclude(query, search);
        }
    }
}
