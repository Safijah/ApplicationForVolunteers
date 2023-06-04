using RadVolontera.Services.Interfaces;
using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Services
{
    public class EmailService : IEmailService
    {
        public async Task SendEmailAsync(string toEmail, string subject, string content)
        {
            var apiKey = "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";
            var client = new SendGridClient(apiKey);
            var from = new EmailAddress("radvolontera@gmail.com", "Rad volontera");
            var to = new EmailAddress(toEmail);
            var msg = MailHelper.CreateSingleEmail(from, to, subject, content, content);
            var response = await client.SendEmailAsync(msg);
        }
    }
}
