using AutoMapper;
using RadVolontera.Models.Payment;

namespace RadVolontera.Services.MappingProfile
{
    public  class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Payment, PaymentResponse>();
            CreateMap<PaymentRequest, Database.Payment>();
            CreateMap<Database.Payment, Models.Payment.Payment>();
        }
    }
}
