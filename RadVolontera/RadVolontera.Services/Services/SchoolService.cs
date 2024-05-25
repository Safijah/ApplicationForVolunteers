using AutoMapper;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class SchoolService : BaseCRUDService<Models.School.School, Database.School, Models.Filters.BaseSearchObject, Models.School.School, Models.School.School, long>, ISchoolService
    {
        public SchoolService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
