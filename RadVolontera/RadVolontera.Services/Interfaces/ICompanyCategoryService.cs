using RadVolontera.Models.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface ICompanyCategoryService : ICRUDService<Models.CompanyCategory.CompanyCategory, CompanyCategorySearcObject, Models.CompanyCategory.CompanyCategoryRequest, Models.CompanyCategory.CompanyCategoryRequest, long>
    {
    }
}
