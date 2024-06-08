using AutoMapper;
using Microsoft.EntityFrameworkCore;
using RadVolontera.Models.AnnualPlanTemplate;
using RadVolontera.Models.Filters;
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
    public class AnnualPlanTemplateService : BaseCRUDService<Models.AnnualPlanTemplate.AnnualPlanTemplate, Database.AnnualPlanTemplate, AnnualPlanTemplateSearchObject, AnnualPlanTemplateRequest, AnnualPlanTemplateRequest, long>, IAnnualTemplateService
    {

        public AnnualPlanTemplateService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<Database.AnnualPlanTemplate> AddFilter(IQueryable<Database.AnnualPlanTemplate> query, AnnualPlanTemplateSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if(search != null)
            {
                if(search.Year != null)
                {
                    filteredQuery = filteredQuery.Where(x => x.Year == search.Year);
                }
            }

            return filteredQuery;
        }

        public override IQueryable<Database.AnnualPlanTemplate> AddInclude(IQueryable<Database.AnnualPlanTemplate> query, AnnualPlanTemplateSearchObject? search = null)
        {
            query = query.Include("MonthlyPlanTemplates");
            return base.AddInclude(query, search);
        }

        public override async Task BeforeInsert(Database.AnnualPlanTemplate entity, Models.AnnualPlanTemplate.AnnualPlanTemplateRequest insert)
        {
            entity.MonthlyPlanTemplates = new List<Database.MonthlyPlanTemplate>();
            foreach (var item in insert.MonthlyPlanTemplates)
            {
                entity.MonthlyPlanTemplates.Add(new MonthlyPlanTemplate()
                {
                    Month = item.Month,
                    Theme = item.Theme,
                });
            }
        }

        public override async Task BeforeUpdate(Database.AnnualPlanTemplate entity, Models.AnnualPlanTemplate.AnnualPlanTemplateRequest update)
        {
            var list = await _context.MonthlyPlanTemplates.Where(x => entity.Id == x.AnnualPlanTemplateId).ToListAsync();
            foreach (var item in list)
            {
                item.Theme = update.MonthlyPlanTemplates.FirstOrDefault(x => x.Month == item.Month)?.Theme ?? "";

            }
        }

        public async Task<List<int>> AvailableYears()
        {
            int currentYear = DateTime.Now.Year;
            int futureYearLimit = currentYear + 5;

            // Get the list of years that already have templates
            var existingYears = _context.AnnualPlanTemplates.Select(t => t.Year).ToHashSet();

            // Find the years that do not have templates
            var availableYears = new List<int>();
            for (int year = currentYear; year <= futureYearLimit; year++)
            {
                if (!existingYears.Contains(year))
                {
                    availableYears.Add(year);
                }
            }

            return availableYears;
        }
    }
}
