using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Domain.Base
{
    public abstract class BaseEntity : ITrackTimes
    {
        public string? CreatedById { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public string? LastModifiedBy { get; set; }

        public DateTime? LastModified { get; set; }
    }
}
