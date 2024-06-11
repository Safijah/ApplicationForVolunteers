using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.CompanyEvent;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Shared;
using RadVolontera.Models.UsefulLinks;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class CompanyEventService : BaseCRUDService<Models.CompanyEvent.CompanyEvent, Database.CompanyEvent, CompanyEventSearchObject, Models.CompanyEvent.CompanyEventRequest, Models.CompanyEvent.CompanyEventRequest, long>, ICompanyEventService
    {

        public CompanyEventService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.CompanyEvent> AddFilter(IQueryable<Database.CompanyEvent> query, CompanyEventSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.CompanyId != null)
                filteredQuery = filteredQuery.Where(x => x.CompanyId == search.CompanyId);

            if ((bool)search?.Registered)
                filteredQuery = filteredQuery.Where(x => x.Mentors.Any(m=>m.Id == search.MentorId));
            
            return filteredQuery;
        }

        public override IQueryable<Database.CompanyEvent> AddInclude(IQueryable<Database.CompanyEvent> query, CompanyEventSearchObject? search = null)
        {
            query = query.Include("Company").Include("Mentors");
            return base.AddInclude(query, search);
        }

        public async Task RegisterForEvent(RegisterForEventRequest registerForEventRequest)
        {
            var value = await _context.CompanyEvent
                .Include(c => c.Mentors)
                .FirstOrDefaultAsync(c => c.Id == registerForEventRequest.CompanyEventId);

            if (value == null)
                throw new ApiException("Company event not found", System.Net.HttpStatusCode.NotFound);

            var user = await _context.Users.FirstOrDefaultAsync(c => c.Id == registerForEventRequest.MentorId);

            if (value == null)
                throw new ApiException("User not found", System.Net.HttpStatusCode.NotFound);

            value.Mentors.Add(user);
            _context.SaveChanges();
        }

        public async Task<bool> IsRegistered(RegisterForEventRequest registerForEventRequest)
        {
            var value = await _context.CompanyEvent
                .Include(c => c.Mentors)
                .FirstOrDefaultAsync(c => c.Id == registerForEventRequest.CompanyEventId);

            if (value == null)
                throw new ApiException("Company event not found", System.Net.HttpStatusCode.NotFound);

            var user = await _context.Users.FirstOrDefaultAsync(c => c.Id == registerForEventRequest.MentorId);

            if (value == null)
                throw new ApiException("User not found", System.Net.HttpStatusCode.NotFound);

            return value.Mentors.Any(c => c.Id == registerForEventRequest.MentorId);
        }

    }
}
