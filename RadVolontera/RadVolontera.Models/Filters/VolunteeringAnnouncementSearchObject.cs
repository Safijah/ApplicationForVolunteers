using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Filters
{
    public class VolunteeringAnnouncementSearchObject : BaseSearchObject
    {
        public  long ?  StatusId { get; set; }
        public string ? MentorId { get; set; }
    }
}
