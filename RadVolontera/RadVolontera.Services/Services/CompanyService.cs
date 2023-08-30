using AutoMapper;
using Microsoft.EntityFrameworkCore;
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

    public class CompanyService : BaseCRUDService<Models.Company.Company, Database.Company, CompanySearchObject, Models.Company.CompanyRequest, Models.Company.CompanyRequest, long>, ICompanyService
    {

        public CompanyService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Company> AddFilter(IQueryable<Database.Company> query, CompanySearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Name))
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.Name));

            if (search?.CityId != null)
                filteredQuery = filteredQuery.Where(x => x.CityId == search.CityId);

            if (search?.CompanyCategoryId != null)
                filteredQuery = filteredQuery.Where(x => x.CompanyCategoryId == search.CompanyCategoryId);


            return filteredQuery;
        }

        public override IQueryable<Database.Company> AddInclude(IQueryable<Database.Company> query, CompanySearchObject? search = null)
        {
            query = query.Include("CompanyCategory").Include("City");
            return base.AddInclude(query, search);
        }
    }
}
