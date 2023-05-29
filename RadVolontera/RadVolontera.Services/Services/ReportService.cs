using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Payment;
using RadVolontera.Models.Report;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class ReportService : BaseCRUDService<Models.Report.Report, Database.Report, ReportSearchObject, ReportRequest, ReportRequest, long>, IReportService
    {
        public ReportService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.Report> AddInclude(IQueryable<Database.Report> query, ReportSearchObject? search = null)
        {
            query = query.Include("Status")
                .Include("VolunteeringAnnouncement")
                .Include("PresentStudents")
                .Include("AbsentStudents");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(Database.Report entity, Models.Report.ReportRequest insert)
        {
            if(insert.PresentStudentsIds  != null && insert.PresentStudentsIds.Any())
            {
                var presentStudents = _context.Users.Select(u => u).Where(u => insert.PresentStudentsIds.Contains(u.Id)).ToList();
                entity.PresentStudents = presentStudents;
            }

            if (insert.AbsentStudentsIds != null && insert.AbsentStudentsIds.Any())
            {
                var absentStudents = _context.Users.Select(u => u).Where(u => insert.AbsentStudentsIds.Contains(u.Id)).ToList();
                entity.AbsentStudents = absentStudents;
            }
        }
    }
}
