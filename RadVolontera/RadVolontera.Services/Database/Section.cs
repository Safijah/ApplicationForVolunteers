using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public  class Section : BaseEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<Notification> Notifications { get; set; }
    }
}
