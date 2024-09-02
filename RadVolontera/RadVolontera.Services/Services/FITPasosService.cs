using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Filters;
using RadVolontera.Models.FITPasos;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class FITPasosService : BaseCRUDService<Models.FITPasos.FITPasos, Database.FITPasos, FITPasosSearchObject, FITPasosRequest, FITPasosRequest, long>, IFITPasosService
    {
        public FITPasosService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.FITPasos> AddInclude(IQueryable<Database.FITPasos> query, FITPasosSearchObject? search = null)
        {

            query = query.Include("User");

            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.FITPasos> AddFilter(IQueryable<Database.FITPasos> query, FITPasosSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.UserId))
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId);
            }

            return filteredQuery;
        }

    }
}
