using RadVolontera.Models.Filters;
using RadVolontera.Models.Payment;
using RadVolontera.Models.UsefulLinks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public  interface IUsefulLinksService : ICRUDService<Models.UsefulLinks.UsefulLinks, UsefulLinksSearchObject, UsefulLinksRequest, UsefulLinksRequest, long>
    {
    }
}
