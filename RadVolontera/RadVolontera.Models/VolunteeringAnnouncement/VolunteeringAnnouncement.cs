using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.VolunteeringAnnouncement
{
    public class VolunteeringAnnouncement
    {
        public long Id { get; set; }
        public string Place { get; set; }
        public string? Reason { get; set; }
        public long AnnouncementStatusId { get; set; }
        public Models.Status.Status AnnouncementStatus { get; set; }
        public long CityId { get; set; }
        public Models.City.City City { get; set; }
        public string MentorId { get; set; }
        public Models.Account.UserResponse Mentor { get; set; }
        public string TimeFrom { get; set; }
        public string TimeTo { get; set; }
        public DateTime Date { get; set; }
        public string Notes { get; set; }
        public bool HasReport { get; set; } = false;
    }
}
