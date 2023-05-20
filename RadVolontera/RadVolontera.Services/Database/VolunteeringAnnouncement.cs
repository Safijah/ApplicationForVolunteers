using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class VolunteeringAnnouncement : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Place { get; set; }
        public long AnnouncementStatusId { get; set; }
        public  Status AnnouncementStatus { get; set; }
        public long CityId { get; set; }
        public City City { get; set; }
        public string MentorId { get; set; }
        public User Mentor { get; set; }
        public int TimeFrom { get; set; }
        public int TimeTo { get; set; }
        public DateTime Date { get; set; }
        public string Notes { get; set; }
        public  Report Report { get; set; }
    }
}
