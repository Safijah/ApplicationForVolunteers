using RadVolontera.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using RadVolontera.Configuration;
using RadVolontera.Services.Interfaces;
using RadVolontera.Services.Services;
using RadVolontera.Middleware;
using Microsoft.AspNetCore.Connections;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;
using RadVolontera.Models.UsefulLinks;

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
builder.Services.AddTransient<ISchoolService, SchoolService>();
builder.Services.AddTransient<IMonitoringService, MonitoringService>();
builder.Services.AddTransient<IAnnualPlanService, AnnualPlanService>();
builder.Services.AddTransient<IAnnualTemplateService, AnnualPlanTemplateService>();
builder.Services.AddTransient<IRecommenderService, RecommenderService>();
builder.Services.AddTransient<IPaymentTicketService, PaymentTicketService>();
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
app.SeedData();
using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    var conn = dataContext.Database.GetConnectionString();
    dataContext.Database.Migrate();
}

app.UseMiddleware<ExceptionMiddleware>();

string hostname = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ";
string username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
string password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
string virtualHost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";



//////////////////////////////////////////////////////////////////////////////////


var factory = new ConnectionFactory
{
    HostName = hostname,
    UserName = username,
    Password = password,
    VirtualHost = virtualHost,
};
using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "links",
                     durable: false,
                     exclusive: false,
                     autoDelete: true,
                     arguments: null);

Console.WriteLine(" [*] Waiting for messages.");

var consumer = new EventingBasicConsumer(channel);
consumer.Received += async (model, ea) =>
{
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    Console.WriteLine(message.ToString());
    var link = JsonSerializer.Deserialize<UsefulLinksRequest>(message);
    using (var scope = app.Services.CreateScope())
    {
        var usefulLinksService = scope.ServiceProvider.GetRequiredService<IUsefulLinksService>();

        if (link != null)
        {
            try
            {
                await usefulLinksService.Insert(link);
            }
            catch (Exception e)
            {

            }
        }
    }
    // Console.WriteLine();
    Console.WriteLine(Environment.GetEnvironmentVariable("Some"));
    Console.WriteLine("Insert useful link finished");
};
channel.BasicConsume(queue: "links",
                     autoAck: true,
                     consumer: consumer);
app.Run();
