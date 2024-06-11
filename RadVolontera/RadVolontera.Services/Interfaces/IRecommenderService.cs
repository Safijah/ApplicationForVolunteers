
using RadVolontera.Models.Filters;
using RadVolontera.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IRecommenderService
    {
        public List<RadVolontera.Models.CompanyEvent.CompanyEvent> TrainRecommendationModel(string userId, long eventId);
    }
}
