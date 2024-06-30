using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Reflection;

namespace RadVolonteraDodatni.Database
{
    public class User
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime? BirthDate { get; set; }
        public string PhoneNumber { get; set; }
        public string PasswordHash { get; set; }
        public string SecurityStamp { get; set; }
        public bool EmailConfirmed { get; set; }
        public virtual ICollection<Monitoring> Monitorings { get; set; } = new List<Monitoring>();
       

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
