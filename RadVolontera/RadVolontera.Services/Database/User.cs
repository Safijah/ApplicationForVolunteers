using RadVolontera.Models.Enums;
using RadVolontera.Services.Domain;
using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Linq;
using System.Numerics;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public  class User : BaseSoftDeleteEntity
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? BirthDate { get; set; }
        public Gender Gender { get; set; }
        public string PhoneNumber { get; set; }
        public string PasswordHash { get; set; }
        public virtual ICollection<Role> Roles { get; set; } = new List<Role>();
        public string SecurityStamp { get; set; }
        public bool EmailConfirmed { get; set; }

        [NotMapped]
        public string FullName
        {
            get
            {
                return FirstName + " " + LastName;
            }
        }
    }
}
