using RadVolontera.Models.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface ICompanyService : ICRUDService<Models.Company.Company, CompanySearchObject, Models.Company.CompanyRequest, Models.Company.CompanyRequest, long>
    {
    }
}
