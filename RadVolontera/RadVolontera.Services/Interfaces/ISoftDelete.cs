using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    internal interface ISoftDelete
    {
        DateTime? DeletedAt { get; set; }
    }
}
