using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Monitoring
{
    public class MonitoringRequest
    {
        public string Notes { get; set; }
        public string MentorId { get; set; }
        public DateTime Date { get; set; }
        public string Url { get; set; }
    }
}
