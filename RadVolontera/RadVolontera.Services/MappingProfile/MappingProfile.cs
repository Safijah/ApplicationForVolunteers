﻿using AutoMapper;
using RadVolontera.Models.City;
using RadVolontera.Models.Company;
using RadVolontera.Models.CompanyCategory;
using RadVolontera.Models.CompanyEvent;
using RadVolontera.Models.Enums;
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
            CreateMap<Database.Payment, PaymentResponse>()
                .ForMember(dest => dest.MonthName, opt => opt.MapFrom(src => Enum.GetName(typeof(Month), src.Month)));
            CreateMap<PaymentRequest, Database.Payment>();
            CreateMap<Database.Payment, Models.Payment.Payment>()
              .ForMember(dest => dest.MonthName, opt => opt.MapFrom(src => Enum.GetName(typeof(Month), src.Month)));
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
            CreateMap<Database.Company, Company>();
            CreateMap<CompanyRequest, Database.Company>();
            CreateMap<Database.CompanyCategory, CompanyCategory>();
            CreateMap<CompanyCategoryRequest, Database.CompanyCategory>();
            CreateMap<Database.CompanyEvent, CompanyEvent>();
            CreateMap<CompanyEventRequest, Database.CompanyEvent>();
        }
    }
}
