using AutoMapper;
using RadVolonteraDodatni.Dtos.Monitoring;
using RadVolonteraDodatni.Dtos.User;

namespace RadVolonteraDodatni.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Monitoring, Monitoring>();
            CreateMap<Database.User, UserResponse>();
        }
    }
}
