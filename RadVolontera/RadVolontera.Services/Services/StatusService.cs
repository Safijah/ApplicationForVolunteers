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
    public  class StatusService : BaseCRUDService<Models.Status.Status, Database.Status, Models.Filters.BaseSearchObject, Models.Status.Status, Models.Status.Status, long>, IStatusService
    {
        public StatusService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
