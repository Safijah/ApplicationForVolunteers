using RadVolontera.Models.Filters;
using RadVolontera.Models.UsefulLinks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface ICompanyEventService : ICRUDService<Models.CompanyEvent.CompanyEvent, CompanyEventSearchObject, Models.CompanyEvent.CompanyEventRequest, Models.CompanyEvent.CompanyEventRequest, long>
    {
    }
}
