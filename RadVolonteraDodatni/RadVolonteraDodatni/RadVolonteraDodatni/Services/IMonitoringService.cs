using RadVolonteraDodatni.Dtos.Monitoring;

namespace RadVolonteraDodatni.Services
{
    public interface IMonitoringService
    {
        public Task<List<Monitoring>> Get(MonitoringSearchObject monitoringSearch);
    }
}
