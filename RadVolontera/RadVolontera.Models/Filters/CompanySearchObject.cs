using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public  class CompanySearchObject : BaseSearchObject
    {
        public long ? CityId { get; set; }
        public long ? CompanyCategoryId { get; set; }
        public string ? Name { get; set; }
    }
}
