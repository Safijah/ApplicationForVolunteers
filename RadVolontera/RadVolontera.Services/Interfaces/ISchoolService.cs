using RadVolontera.Models.School;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface ISchoolService : ICRUDService<Models.School.School, Models.Filters.BaseSearchObject, School, School, long>
    {
    }
}
