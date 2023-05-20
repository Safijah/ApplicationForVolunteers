using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public  class UsefulLinks : BaseEntity
    {
        public long Id { get; set; }
        public string UrlLink { get; set; }
        public string Name { get; set; }
        public string AdminId { get; set; }
        public User Admin { get; set; }
    }
}
