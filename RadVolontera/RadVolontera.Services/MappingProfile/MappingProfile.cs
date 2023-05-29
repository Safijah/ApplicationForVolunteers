using AutoMapper;
using RadVolontera.Models.City;
using RadVolontera.Models.Notification;
using RadVolontera.Models.Payment;
using RadVolontera.Models.Report;
using RadVolontera.Models.Section;
using RadVolontera.Models.Status;
using RadVolontera.Models.UsefulLinks;
using RadVolontera.Models.VolunteeringAnnouncement;

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
            CreateMap<Database.Status, Status>();
            CreateMap<Database.City, City>();
            CreateMap<Database.VolunteeringAnnouncement, VolunteeringAnnouncement>();
            CreateMap<VolunteeringAnnouncementRequest, Database.VolunteeringAnnouncement>();
            CreateMap<Database.Report, Report>();
            CreateMap<ReportRequest, Database.Report>();
        }
    }
}
