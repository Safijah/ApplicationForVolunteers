using AutoMapper;
using RadVolontera.Models.Notification;
using RadVolontera.Models.Payment;
using RadVolontera.Models.Section;
using RadVolontera.Models.UsefulLinks;

namespace RadVolontera.Services.MappingProfile
{
    public  class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Payment, PaymentResponse>();
            CreateMap<PaymentRequest, Database.Payment>();
            CreateMap<Database.Payment, Models.Payment.Payment>();
            CreateMap<Database.User, Models.Account.UserResponse>();
            CreateMap<Database.UsefulLinks, UsefulLinks>();
            CreateMap<UsefulLinksRequest, Database.UsefulLinks>();
            CreateMap<Database.Notification, Notification>();
            CreateMap<NotificationRequest, Database.Notification>();
            CreateMap<Database.Section, Section>();
        }
    }
}
