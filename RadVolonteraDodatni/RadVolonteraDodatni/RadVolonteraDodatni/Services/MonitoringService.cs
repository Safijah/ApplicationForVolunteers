using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolonteraDodatni.Database;
using RadVolonteraDodatni.Dtos.Monitoring;

namespace RadVolonteraDodatni.Services
{
    public class MonitoringService : IMonitoringService
    {
        private AppDbContext _appDbContext;
        private IMapper _mapper;
        public MonitoringService(AppDbContext appDbContext, IMapper mapper)
        {
            _appDbContext = appDbContext;
            _mapper = mapper;
        }

        public async Task<List<Dtos.Monitoring.Monitoring>> Get(MonitoringSearchObject monitoringSearch)
        {
            var monitorings = await _appDbContext.Monitoring.ToListAsync();

            if (monitoringSearch != null)
            {
                if (monitoringSearch.MentorId != null)
                    monitorings = monitorings.Where(m => m.MentorId == monitoringSearch.MentorId).ToList();

                if ((bool)monitoringSearch.ForToday!)
                    monitorings = monitorings.Where(m => m.Date.Date == DateTime.Now.Date).ToList();
            }

            return _mapper.Map<List<Dtos.Monitoring.Monitoring>>(monitorings);

        }
    }
}
