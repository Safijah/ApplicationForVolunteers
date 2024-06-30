using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Connections;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RabbitMQ.Client;
using RadVolonteraDodatni.Dtos.Monitoring;
using RadVolonteraDodatni.Services;
using System.Text;

namespace RadVolonteraDodatni.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MonitoringController : ControllerBase
    {
        private IMonitoringService _monitoringService;
        public MonitoringController(IMonitoringService monitoringService)
        {
            _monitoringService = monitoringService;
        }

        [HttpGet]
        public virtual async Task<List<Dtos.Monitoring.Monitoring>> Get([FromQuery] MonitoringSearchObject monitoringSearch)
        {
            var result = await _monitoringService.Get(monitoringSearch);
            var factory = new ConnectionFactory
            {
                HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitMQ"
            };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "monitorings",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: true,
                                 arguments: null);


            var json = JsonConvert.SerializeObject(result);

            var body = Encoding.UTF8.GetBytes(json);

            Console.WriteLine($"Sending monitorings: {json}");

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "monitorings",

                                 body: body);
            return result;
        }
    }
}
