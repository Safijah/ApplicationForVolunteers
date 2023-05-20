using RadVolontera.Services.Database;
using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Configuration
{
    internal class RolesSeed
    {
        public static Role[] Data =
        {
            new Role{ Id="18d19d79-4b90-4ae0-93ff-926b47a2ee49", Name=Roles.Admin},
            new Role{ Id= "af6475d1-b099-4c74-a7ea-1e4acfc11dad", Name=Roles.Mentor},
            new Role{ Id= "822508ac-1c1b-c741-6ee1-5efcc27dd6", Name=Roles.Student}
        };
    }
}
