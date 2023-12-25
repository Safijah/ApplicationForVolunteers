using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using OpenHtmlToPdf;
using RadVolontera.Models.Filters;
using RadVolontera.Models.Payment;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class PaymentService : BaseCRUDService<Models.Payment.Payment, Database.Payment, PaymentSearchObject, PaymentRequest, PaymentRequest, long>, IPaymentService
    {
        public readonly IPdfGeneratorService _pdfGeneratorService;
        public PaymentService(AppDbContext context, IMapper mapper,IPdfGeneratorService pdfGeneratorService) : base(context, mapper)
        {
            _pdfGeneratorService = pdfGeneratorService;
        }

        public override IQueryable<Database.Payment> AddInclude(IQueryable<Database.Payment> query, PaymentSearchObject? search = null)
        {
            if (search?.IncludeStudent == true)
            {
                query = query.Include("Student");
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<Database.Payment> AddFilter(IQueryable<Database.Payment> query, PaymentSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.StudentId))
            {
                filteredQuery = filteredQuery.Where(x => x.StudentId == search.StudentId);
            }

            if (search.Month.HasValue && search.Month.Value != Models.Enums.Month.All)
            {
                filteredQuery = filteredQuery.Where(x => x.Month == search.Month);
            }

            return filteredQuery;
        }

        public List<RadVolontera.Models.Payment.PaymentReportResponse> GetPaymentReport( PaymentReportSearchObject request)
        {
            var result = new List<RadVolontera.Models.Payment.PaymentReportResponse>();
            for (int i = 1; i <= 12; i++)
            {
                var payments = _context.Payments.Where(p => p.Month == (Models.Enums.Month)i);

                if (request != null)
                {
                    if (!string.IsNullOrWhiteSpace(request?.StudentId)) {
                        payments = payments.Where(p => p.StudentId == request.StudentId);
                    }

                    if (request?.Year != null)
                    {
                        payments = payments.Where(p => p.Year == request.Year);
                    }
                }
                var report = new RadVolontera.Models.Payment.PaymentReportResponse()
                {
                    Month = (Models.Enums.Month)i,
                    MonthName = ((Models.Enums.Month)i).ToString(),
                    Amount = payments.Sum(p => p.Amount)
                };

                result.Add(report);
            }

            return result.ToList();
        }

        public async  Task<byte[]> GeneratePaymentReportPdf(){
            var html =await _pdfGeneratorService.GeneratePaymentReportPdf();
            var pdf = Pdf
               .From(html)
               .WithMargins(PaperMargins.All(Length.Centimeters(2)))
               .WithTitle("Kontrakt")
               .OfSize(OpenHtmlToPdf.PaperSize.A4)
               .Portrait()
               .Content();

            return pdf ;
        }
    }
}
