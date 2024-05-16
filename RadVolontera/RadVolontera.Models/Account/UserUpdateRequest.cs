using RadVolontera.Models.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Account
{
    public class UserUpdateRequest
    {
        [Required, MaxLength(50)]
        public string FirstName { get; set; }
        [Required, MaxLength(50)]
        public string LastName { get; set; }
        [EmailAddress]
        [Required, MaxLength(100)]
        public string Email { get; set; }
        [Required]
        public Gender Gender { get; set; }
        public DateTime? BirthDate { get; set; }
        [MaxLength(50)]
        public string PhoneNumber { get; set; }
    }
}
