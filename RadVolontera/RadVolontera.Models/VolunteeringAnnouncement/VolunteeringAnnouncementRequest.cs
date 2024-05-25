using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.VolunteeringAnnouncement
{
    public class VolunteeringAnnouncementRequest
    {
        public string Place { get; set; }
        public long AnnouncementStatusId { get; set; }
        public long CityId { get; set; }
        public string MentorId { get; set; }
        public string TimeFrom { get; set; }
        public string TimeTo { get; set; }
        public DateTime Date { get; set; }
        public string Notes { get; set; }
    }
}
