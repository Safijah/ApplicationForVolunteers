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
 
    public class MonitoringService : BaseCRUDService<Models.Monitoring.Monitoring, Database.Monitoring, MonitoringSearchObject, Models.Monitoring.MonitoringRequest, Models.Monitoring.MonitoringRequest, long>, IMonitoringService
    {

        public MonitoringService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Monitoring> AddFilter(IQueryable<Database.Monitoring> query, MonitoringSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search!=null && !string.IsNullOrWhiteSpace(search?.MentorId))
                filteredQuery = filteredQuery.Where(x => x.MentorId==search.MentorId);
            
            if(search != null && search.ForToday == true)
                filteredQuery = filteredQuery.Where(x=>x.Date.Date == DateTime.Now.Date);

            return filteredQuery;
        }

        public override IQueryable<Database.Monitoring> AddInclude(IQueryable<Database.Monitoring> query, MonitoringSearchObject? search = null)
        {
            query = query.Include("Mentor");
            return base.AddInclude(query, search);
        }
    }
}
