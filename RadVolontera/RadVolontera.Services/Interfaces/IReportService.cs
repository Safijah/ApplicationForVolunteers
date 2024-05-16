﻿using RadVolontera.Models.Filters;
using RadVolontera.Models.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public  interface IReportService: ICRUDService<Models.Report.Report, ReportSearchObject, ReportRequest, ReportRequest, long>
    {
        Task<Report> ChangeReportStatus(ChangeReportStatusRequest request);
        Task<PagedResult<Report>> MentorReports(string mentorId);
    }
}
