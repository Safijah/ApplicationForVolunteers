using RadVolontera.Models.Status;
using RadVolontera.Services.Database;


namespace RadVolontera.Services.Interfaces
{
    public  interface IStatusService : ICRUDService<Models.Status.Status, Models.Filters.BaseSearchObject, Models.Status.Status, Models.Status.Status, long>
    {
    }
}
