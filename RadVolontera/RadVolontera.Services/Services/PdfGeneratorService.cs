using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class PdfGeneratorService : IPdfGeneratorService
    {
        public readonly AppDbContext _context;
        public PdfGeneratorService(AppDbContext context)
        {
            _context = context;
        }
        public async Task<string> GeneratePaymentReportPdf()
        {
            string stylePath = (Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\Resources\style.css").Replace("\\", "/");
            StringBuilder generatedCss = GetStringFromFile(stylePath);
            var test= await _context.SaveChangesAsync();
            string html = $@"
            <!DOCTYPE html>
            <html>
            <head>
            <meta name='viewport' content='width=device-width,initial-scale=1.0'>
                        <meta charset='UTF-8'>
                <title>Title</title>
                <style type='text/css'> {generatedCss} </style>       
            </head>
            <body>
               <div  class=""full-width""><span>Safija hehe</span></div>
            </body>
            </html>";

            return html;
        }

        public static StringBuilder GetStringFromFile(string path)
        {
            StringBuilder sb = new StringBuilder(System.IO.File.ReadAllText(path, Encoding.UTF8));
            return sb;
        }
    }
}
