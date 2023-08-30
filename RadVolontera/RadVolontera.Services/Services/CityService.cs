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
    public class CityService : BaseCRUDService<Models.City.City, Database.City, Models.Filters.BaseSearchObject, Models.City.City, Models.City.City, long>, ICityService
    {
        public CityService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
