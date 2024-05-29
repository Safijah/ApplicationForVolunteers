using RadVolontera.Models.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IMonitoringService : ICRUDService<Models.Monitoring.Monitoring, MonitoringSearchObject, Models.Monitoring.MonitoringRequest, Models.Monitoring.MonitoringRequest, long>
    {
    }
}
