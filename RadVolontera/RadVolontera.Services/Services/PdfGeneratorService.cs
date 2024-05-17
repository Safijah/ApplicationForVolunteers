using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System.Reflection;
using System.Text;
using System;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Globalization;
using RadVolontera.Models.Enums;

public class PdfGeneratorService : IPdfGeneratorService
{
    private readonly AppDbContext _context;

    public PdfGeneratorService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<string> GeneratePaymentReportPdf(int selectedYear, string? studentId)
    {
        // Retrieve data based on the filter parameters
        var paymentData = await _context.Payments
            .Include(p => p.Student)
            .Where(p => p.Year == selectedYear && (studentId == null || (p.StudentId == studentId)))
            .ToListAsync();

        User studentData = null;
        if (!string.IsNullOrEmpty(studentId))
        {
            studentData = await _context.Users.FirstOrDefaultAsync(s => s.Id == studentId);
        }
        // Generate PDF report dynamically
        var pdfHtml = await GeneratePdfReport(paymentData, studentData, selectedYear);

        return pdfHtml;
    }

    private async Task<string> GeneratePdfReport(List<Payment> paymentData, User? student, int selectedYear)
    {
        string stylePath = (Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\Resources\style.css").Replace("\\", "/");
        StringBuilder generatedCss = GetStringFromFile(stylePath);
        string logo = GetImageFromFolder(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\Resources\logo.jpg");

        string studentInfo = student != null ? $"Student: {student.FullName}" : "All Students";
        string dateInfo = $"Year: {selectedYear}";
        string currentDate = DateTime.Now.ToString("MMMM dd, yyyy");

        // Generate the HTML content for the table
        string tableContent = student != null ? GenerateStudentTable(paymentData) : GenerateAllStudentsTable(paymentData);

        string html = $@"
            <!DOCTYPE html>
            <html>
            <head>
            <meta name='viewport' content='width=device-width,initial-scale=1.0'>
            <meta charset='UTF-8'>
                <title>Payment Report</title>
                <style type='text/css'> {generatedCss} </style>       
            </head>
            <body>
               <div class='container'>
                    <div class='header'>
                       <div class='right-logo'><img src='data:image/jpeg;base64,{logo}' /></div>
                    </div>
                    <div style='height:60px;'></div>
                    <div class='center-text'>
                        <h1>Payment Reports</h1>
                        <h2>{dateInfo}</h2>
                        <h3>{studentInfo}</h3>
                    </div>
                   <div style='page-break-before: always'> </div>
                    <div class='table-container'>
                        {tableContent}
                    </div>
                </div>
                <div class='footer'>
                    <p class='current-date'>{currentDate}</p>
                </div>
            </body>
            </html>";

        return html;
    }

    private string GenerateStudentTable(List<Payment> paymentData)
    {
        // Generate the HTML table
        StringBuilder sb = new StringBuilder();
        sb.Append("<table>");
        sb.Append("<tr><th>Month</th><th>Total Amount</th></tr>");

        double totalForAllMonths = 0;

        // Iterate over each month from January to December
        for (int month = 1; month <= 12; month++)
        {
            // Check if there is payment data available for the current month
            var paymentsForMonth = paymentData.Where(p => p.Month == (Month)month);

            // If there are payments for the current month, calculate the total amount
            double totalAmount = paymentsForMonth.Any() ? paymentsForMonth.Sum(p => p.Amount) : 0;

            // Get the name of the month
            string monthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(month);

            // Add the table row for the current month
            sb.Append($"<tr><td>{monthName}</td><td>{totalAmount} BAM</td></tr>");

            // Update the total for all months
            totalForAllMonths += totalAmount;
        }

        // Add a row for the total amount for all months
        sb.Append($"<tr  style='color: white;' class='total'><td>Total</td><td>{totalForAllMonths} BAM</td></tr>");

        sb.Append("</table>");

        return sb.ToString();
    }


    private string GenerateAllStudentsTable(List<Payment> paymentData)
    {
        // Generate the HTML table
        StringBuilder sb = new StringBuilder();
        sb.Append("<table>");
        sb.Append("<tr><th>Student Name</th>");

        // Iterate over each month from January to December and add month names as table headers
        for (int month = 1; month <= 12; month++)
        {
            string monthName = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(month);
            sb.Append($"<th>{monthName}</th>");
        }

        // Add a column for the total amount for each student
        sb.Append("<th>Total</th></tr>");

        // Get distinct list of students
        var students = paymentData.Select(p => p.Student).Distinct();

        // Iterate over each student
        foreach (var student in students)
        {
            sb.Append($"<tr><td>{student?.FullName ?? "Unknown"}</td>");

            // Variable to store total amount for the student
            double studentTotal = 0;

            // Iterate over each month from January to December
            for (int month = 1; month <= 12; month++)
            {
                // Get the total amount for the current month and student
                double totalAmount = paymentData
                    .Where(p => p.StudentId == student.Id && p.Month == (Month)month)
                    .Sum(p => p.Amount);

                // Add the total amount for the current month and student as a table cell
                sb.Append($"<td>{totalAmount} BAM</td>");

                // Update the total amount for the student
                studentTotal += totalAmount;
            }

            // Add the total amount for the student as a table cell
            sb.Append($"<td>{studentTotal} BAM</td>");

            sb.Append("</tr>");
        }

        // Add a row for the global total
        sb.Append("<tr  style='color: white;' class='total'><td>Global Total</td>");
        double globalTotal = 0;
        // Calculate the total amount for each month across all students
        for (int month = 1; month <= 12; month++)
        {
            double monthTotal = paymentData
                .Where(p => p.Month == (Month)month)
                .Sum(p => p.Amount);

            // Add the total amount for the current month as a table cell
            sb.Append($"<td>{monthTotal} BAM</td>");
            globalTotal += monthTotal;
        }

        sb.Append($"<td>{globalTotal} BAM</td>");

        sb.Append("</tr></table>");

        return sb.ToString();
    }

    private static string GetImageFromFolder(string path)
    {
        try
        {
            using (Image image = Image.FromFile(path))
            {
                using (MemoryStream m = new MemoryStream())
                {
                    image.Save(m, image.RawFormat);
                    byte[] imageBytes = m.ToArray();

                    string base64String = Convert.ToBase64String(imageBytes);
                    return base64String;
                }
            }
        }
        catch (Exception)
        {
            return string.Empty;
        }
    }

    public static StringBuilder GetStringFromFile(string path)
    {
        StringBuilder sb = new StringBuilder(File.ReadAllText(path, Encoding.UTF8));
        return sb;
    }

}
