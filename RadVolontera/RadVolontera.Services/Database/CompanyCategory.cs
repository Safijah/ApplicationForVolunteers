using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class CompanyCategory
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public virtual ICollection<Company> Companies { get; set; } = new List<Company>();
    }
}
