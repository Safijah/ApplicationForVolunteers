using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Company
{
    public  class Company
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public long CityId { get; set; }
        public City.City City { get; set; }
        public long CompanyCategoryId { get; set; }
        public CompanyCategory.CompanyCategory CompanyCategory { get; set; }
    }
}
