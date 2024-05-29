using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Report
{
    public  class ChangeReportStatusRequest
    {
        public long ReportId { get; set; }
        public long? StausId { get; set; }
        public string? Status { get; set; }
        public string? Notes { get; set; }
        public string ? Reason { get; set; }
    }
}
