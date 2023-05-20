using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Domain.Base
{
    public class BaseSoftDeleteEntity : BaseEntity, ISoftDelete
    {
        public DateTime? DeletedAt { get; set; }

        public bool IsDeleted => DeletedAt.HasValue;
    }
}
