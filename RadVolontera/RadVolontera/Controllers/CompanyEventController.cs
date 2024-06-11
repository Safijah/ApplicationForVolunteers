using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using RadVolontera.Models.CompanyEvent;
using RadVolontera.Models.Filters;
using RadVolontera.Services.Interfaces;

namespace RadVolontera.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyEventController : BaseCRUDController<Models.CompanyEvent.CompanyEvent, Models.Filters.CompanyEventSearchObject, Models.CompanyEvent.CompanyEventRequest, Models.CompanyEvent.CompanyEventRequest, long>
    {
        private readonly IRecommenderService _recommenderService;

        public CompanyEventController(ILogger<BaseController<Models.CompanyEvent.CompanyEvent, Models.Filters.CompanyEventSearchObject, long>> logger, ICompanyEventService service, IRecommenderService recommenderService) : base(logger, service)
        {
            _recommenderService = recommenderService;
        }

        [HttpPost("register-for-event")]
        public virtual async Task StudentAnnouncements([FromBody] RegisterForEventRequest registerForEventRequest)
        {
            await (_service as ICompanyEventService).RegisterForEvent(registerForEventRequest);
        }

        [HttpPost("is-registered")]
        public virtual async Task<bool> IsRegistered([FromBody] RegisterForEventRequest registerForEventRequest)
        {
            var result = await (_service as ICompanyEventService).IsRegistered(registerForEventRequest);
            return result;
        }

        [HttpPost("reccomended")]
        public virtual  List<CompanyEvent> Reccomended([FromBody] RegisterForEventRequest registerForEventRequest)
        {
            var result = _recommenderService.TrainRecommendationModel(registerForEventRequest.MentorId, registerForEventRequest.CompanyEventId);
            return result;
        }
    }
}
