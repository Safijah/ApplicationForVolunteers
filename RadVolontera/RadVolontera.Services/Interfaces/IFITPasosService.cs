using RadVolontera.Models.Filters;
using RadVolontera.Models.FITPasos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IFITPasosService : ICRUDService<Models.FITPasos.FITPasos, FITPasosSearchObject, FITPasosRequest, FITPasosRequest, long>
    {
    }
}
