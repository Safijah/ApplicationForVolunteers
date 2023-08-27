using RadVolontera.Models.Filters;
using RadVolontera.Models.Notification;
using RadVolontera.Models.Section;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface ISectionService : ICRUDService<Models.Section.Section, Models.Filters.BaseSearchObject, Section, Section, long>
    {
    }
}
