using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RadVolontera.Services.Database;
using RadVolontera.Services.Interfaces;
using System.Reflection;
using System.Text;
using System;
using System.Drawing;
using System.IO;

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

        var studentData = new User();
        if (!studentId.IsNullOrEmpty())
        {
            studentData = _context.Users.FirstOrDefault(s => s.Id == studentId);
        }
        // Generate PDF report dynamically
        var pdfHtml = await GeneratePdfReport(paymentData, studentData);

        return pdfHtml;
    }

    private async Task<string> GeneratePdfReport(List<Payment> paymentData, User? student)
    {
        string stylePath = (Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\Resources\style.css").Replace("\\", "/");
        StringBuilder generatedCss = GetStringFromFile(stylePath);
        string logo = GetImageFromFolder(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\Resources\logo.jpg");
        return "";

    }

    private static string GetImageFromFolder(string path)
    {
        try
        {
            using ( Image image = Image.FromFile(path))
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
