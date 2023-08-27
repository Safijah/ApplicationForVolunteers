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
        public string SecurityStamp { get; set; }
        public bool EmailConfirmed { get; set; }
        public long? SchoolId { get; set; }
        public  School? School { get; set; }
        public long ? CityId { get; set; }
        public City? City { get; set; }
        public string? MentorId { get; set; }
        public User Mentor { get; set; }
        public virtual ICollection<Role> Roles { get; set; } = new List<Role>();
        public virtual ICollection<VolunteeringAnnouncement> AnnouncementMentors { get; set; } = new List<VolunteeringAnnouncement>();
        public virtual ICollection<Report> Reports { get; set; } = new List<Report>();
        public virtual ICollection<Report> VolunteersPresent { get; set; } = new List<Report>();
        public virtual ICollection<Report> AbsentForVolunteering { get; set; } = new List<Report>();
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
        public virtual ICollection<UsefulLinks> UsefulLinks { get; set; } = new List<UsefulLinks>();
        public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();

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
