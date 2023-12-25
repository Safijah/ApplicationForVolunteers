using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public interface IPdfGeneratorService
    {
        Task<string> GeneratePaymentReportPdf ();
    }
}
