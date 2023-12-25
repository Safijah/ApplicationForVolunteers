using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Report;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : BaseCRUDController<Models.Payment.Payment, Models.Filters.PaymentSearchObject, Models.Payment.PaymentRequest, Models.Payment.PaymentRequest,long>
    {
        public PaymentController(ILogger<BaseController<Models.Payment.Payment, Models.Filters.PaymentSearchObject, long>> logger, IPaymentService service) : base(logger, service)
        {

        }

        [HttpGet("payment-report")]
        public virtual List<RadVolontera.Models.Payment.PaymentReportResponse> GetPaymentReport([FromQuery]PaymentReportSearchObject request)
        {
            var result =  (_service as IPaymentService).GetPaymentReport(request);
            return result.ToList();
        }


        [HttpGet("pdf-report")]
        public virtual async Task<IActionResult> GeneratePdf()
        {
            var result = await (_service as IPaymentService).GeneratePaymentReportPdf();
            var fileContentResult = new FileContentResult(result, "application/pdf")
            {
                FileDownloadName = "example.pdf"
            };
            return fileContentResult;
        }
    }
}
