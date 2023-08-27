using RadVolontera.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Report
{
    public  class Report
    {
        public long Id { get; set; }
        public string Notes { get; set; }
        public string Goal { get; set; }
        public string VolunteerActivities { get; set; }
        public string Themes { get; set; }
        public long StatusId { get; set; }
        public Models.Status.Status Status { get; set; }
        public long VolunteeringAnnouncementId { get; set; }
        public Models.VolunteeringAnnouncement.VolunteeringAnnouncement VolunteeringAnnouncement { get; set; }
        public List<UserResponse> PresentStudents { get; set; }
        public List<UserResponse> AbsentStudents { get; set; }
        public Models.Account.UserResponse Mentor { get; set; }
    }
}
