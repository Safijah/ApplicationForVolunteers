using RadVolontera.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using RadVolontera.Configuration;
using RadVolontera.Services.Interfaces;
using RadVolontera.Services.Services;
using RadVolontera.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddTransient<IPaymentService, PaymentService>();
builder.Services.AddTransient<IUsefulLinksService, UsefulLinksService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<IVolunteeringAnnouncementService, VolunteeringAnnouncementService>();
builder.Services.AddTransient<IReportService, ReportService>();
builder.Services.AddTransient<IEmailService, EmailService>();
builder.Services.AddTransient<ISectionService, SectionService>();
builder.Services.AddTransient<IStatusService, StatusService>();
builder.Services.AddTransient<ICompanyCategoryService, CompanyCategoryService>();
builder.Services.AddTransient<ICompanyService, CompanyService>();
builder.Services.AddTransient<ICompanyEventService, CompanyEventService>();
builder.Services.AddTransient<ICityService, CityService>();
builder.Services.AddTransient<IPdfGeneratorService, PdfGeneratorService>();
builder.Services.AddTransient<ExceptionMiddleware>();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddSwaggerGen();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddEFCoreInfrastructure(builder.Configuration);
builder.Services.AddIdentityInfrastructure(builder.Configuration);
builder.Services.AddSwaggerConfiguration();
builder.Services.AddAutoMapper(typeof(IPaymentService));
var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Authorization");

});
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var conn = dataContext.Database.GetConnectionString();
    dataContext.Database.Migrate();
}

app.UseMiddleware<ExceptionMiddleware>();

app.Run();
