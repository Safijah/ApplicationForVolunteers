using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class School : BaseEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public long SchoolTypeId { get; set; }
        public  SchoolType SchoolType  { get; set; }
        public ICollection<User> Students { get; set; }
    }
}
