using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Filters;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class CompanyCategoryService : BaseCRUDService<Models.CompanyCategory.CompanyCategory, Database.CompanyCategory, CompanyCategorySearcObject, Models.CompanyCategory.CompanyCategoryRequest, Models.CompanyCategory.CompanyCategoryRequest, long>, ICompanyCategoryService
    {

        public CompanyCategoryService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.CompanyCategory> AddFilter(IQueryable<Database.CompanyCategory> query, CompanyCategorySearcObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrEmpty(search.Name))
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.Name));

            return filteredQuery;
        }
    }
}
