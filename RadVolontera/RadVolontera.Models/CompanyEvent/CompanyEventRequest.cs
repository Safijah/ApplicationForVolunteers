using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.CompanyEvent
{
    public  class CompanyEventRequest
    {
        public long CompanyId { get; set; }
        public string EventName { get; set; }
        public DateTime EventDate { get; set; }
        public string Location { get; set; }
        public string Time { get; set; }
        public int Price { get; set; }
    }
}
