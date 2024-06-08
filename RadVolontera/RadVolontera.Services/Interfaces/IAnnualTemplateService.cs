using RadVolontera.Models.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IAnnualTemplateService : ICRUDService<Models.AnnualPlanTemplate.AnnualPlanTemplate, AnnualPlanTemplateSearchObject, Models.AnnualPlanTemplate.AnnualPlanTemplateRequest, Models.AnnualPlanTemplate.AnnualPlanTemplateRequest, long>
    {
        public Task<List<int>> AvailableYears();
    }
}
