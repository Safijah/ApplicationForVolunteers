using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.VolunteeringAnnouncement
{
    public class ChangeStatusRequest
    {
        public long VolunteeringAnnouncementId { get; set; }
        public long StausId { get; set; }
        public string? Status { get; set; }
        public string? Notes { get; set; }
    }
}
