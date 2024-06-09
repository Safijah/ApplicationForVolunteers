using RadVolontera.Models.AnnualPlan;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Notification;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IAnnualPlanService : ICRUDService<Models.AnnualPlan.AnnualPlan, AnnualPlanSearchObject, AnnualPlanRequest, AnnualPlanRequest, long>
    {
        public Task<List<int>> AvailableYears(string mentorId);
    }
}
