using AutoMapper;
using RadVolontera.Models.Section;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Services.Services
{
    public class SectionService : BaseCRUDService<Models.Section.Section, Database.Section, Models.Filters.BaseSearchObject, Models.Section.Section, Models.Section.Section, long>, ISectionService
    {
        public SectionService(AppDbContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }


}
