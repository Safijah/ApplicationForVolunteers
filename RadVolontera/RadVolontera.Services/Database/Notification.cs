using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class Notification : BaseEntity
    {
        public long Id { get; set; }
        public string Heading { get; set; }
        public string Content  { get; set; }
        public long SectionId { get; set; }
        public Section Section { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
    }
}
