using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface ICRUDService<T, TSearch, TInsert, TUpdate, TId> : IService<T, TSearch, TId> where TSearch : class
    {
        Task<T> Insert(TInsert insert);
        Task<T> Update(TId id, TUpdate update);
    }
}
