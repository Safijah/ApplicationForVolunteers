using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Report
{
    public  class ReportRequest
    {
        public string Notes { get; set; }
        public string Goal { get; set; }
        public string VolunteerActivities { get; set; }
        public string Themes { get; set; }
        public string MentorId { get; set; }
        public long StatusId { get; set; }
        public long VolunteeringAnnouncementId { get; set; }
        public List<string> PresentStudentsIds { get; set; }
        public List<string> AbsentStudentsIds { get; set; }
    }
}
