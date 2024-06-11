using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.AnnualPlan;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Notification;
using RadVolontera.Models.Report;
using RadVolontera.Models.Shared;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{

    public class AnnualPlanService : BaseCRUDService<Models.AnnualPlan.AnnualPlan, Database.AnnualPlan, AnnualPlanSearchObject, AnnualPlanRequest, AnnualPlanRequest, long>, IAnnualPlanService
    {
        public AnnualPlanService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.AnnualPlan> AddFilter(IQueryable<Database.AnnualPlan> query, AnnualPlanSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            if (search != null)
            {
                if (search.Year != null)
                {
                    filteredQuery = filteredQuery.Where(x => x.Year == search.Year);
                }

                if (!string.IsNullOrWhiteSpace(search?.MentorId))
                {
                    filteredQuery = filteredQuery.Where(x => x.MentorId == search.MentorId);
                }

                if (search?.StatusId != null)
                {
                    filteredQuery = filteredQuery.Where(x => x.StatusId == search.StatusId);
                }

            }

            return filteredQuery;
        }

        public override IQueryable<Database.AnnualPlan> AddInclude(IQueryable<Database.AnnualPlan> query, AnnualPlanSearchObject? search = null)
        {
            query = query.Include("Status").Include("Mentor").Include("MonthlyPlans");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(Database.AnnualPlan entity, Models.AnnualPlan.AnnualPlanRequest insert)
        {
            entity.MonthlyPlans = new List<Database.MonthlyPlan>();
            foreach (var item in insert.MonthlyPlans)
            {
                entity.MonthlyPlans.Add(new MonthlyPlan()
                {
                    Month = item.Month,
                    Theme1 = item.Theme1,
                    Theme2 = item.Theme2,
                    Goals1 = item.Goals1,
                    Goals2 = item.Goals2,
                });
            }

            var status = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "On hold");
            if (status != null)
            {
                entity.StatusId = status.Id;
            }
        }

        public override async Task BeforeUpdate(Database.AnnualPlan entity, Models.AnnualPlan.AnnualPlanRequest update)
        {
            var list = await _context.MonthlyPlans.Where(x => entity.Id == x.AnualPlanId).ToListAsync();
            foreach (var item in list)
            {
                item.Theme1 = update.MonthlyPlans.FirstOrDefault(x => x.Month == item.Month)?.Theme1 ?? "";
                item.Theme2 = update.MonthlyPlans.FirstOrDefault(x => x.Month == item.Month)?.Theme2 ?? "";
                item.Goals1 = update.MonthlyPlans.FirstOrDefault(x => x.Month == item.Month)?.Goals1 ?? "";
                item.Goals2 = update.MonthlyPlans.FirstOrDefault(x => x.Month == item.Month)?.Goals2 ?? "";
            }

            var currentStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Id == entity.StatusId);
            var onHoldStatus = await _context.Statuses.FirstOrDefaultAsync(s => s.Name == "On hold");
            if (currentStatus != null && currentStatus.Name == "Rejected")
            {
                update.StatusId = onHoldStatus?.Id ?? entity.StatusId;
            }
            else
            {
                update.StatusId = entity.StatusId;
            }
            update.AnnualPlanTemplateId = entity.AnnualPlanTemplateId;
        }

        public async Task<List<int>> AvailableYears(string mentorId)
        {
            int currentYear = DateTime.Now.Year;
            int futureYearLimit = currentYear + 5;

            // Get the list of years that already have templates
            var existingYears = _context.AnnualPlans.Where(a => a.MentorId == mentorId).Select(t => t.Year).ToHashSet();
            var existingTemplateYears = _context.AnnualPlanTemplates.Select(t => t.Year).ToHashSet();

            // Find the years that do not have templates
            var availableYears = new List<int>();
            for (int year = currentYear; year <= futureYearLimit; year++)
            {
                if (!existingYears.Contains(year) && existingTemplateYears.Contains(year))
                {
                    availableYears.Add(year);
                }
            }

            return availableYears;
        }
    }
}


