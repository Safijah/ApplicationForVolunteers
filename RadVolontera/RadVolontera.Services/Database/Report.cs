using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class Report : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Notes { get; set; }
        public string Goal { get; set; }
        public string VolunteerActivities { get; set; }
        public string Themes { get; set; }
        public long StatusId { get; set; }
        public  Status Status { get; set; }
        public long VolunteeringAnnouncementId { get; set; }
        public  VolunteeringAnnouncement VolunteeringAnnouncement { get; set; }
        public string MentorId { get; set; }
        public User Mentor { get; set; }
        public ICollection<User> PresentStudents{ get; set; }
        public ICollection<User> AbsentStudents { get; set; }
        public string? Reason { get; set; }
    }
}
