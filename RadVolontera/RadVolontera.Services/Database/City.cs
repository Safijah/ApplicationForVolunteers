using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class City : BaseEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<VolunteeringAnnouncement> VolunteeringAnnouncements { get; set; }
        public ICollection<User> Users { get; set; }
    }
}
