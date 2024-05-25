using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class Monitoring :BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Notes { get; set; }
        public string MentorId { get; set; }
        public User Mentor { get; set; }
        public DateTime Date { get; set; }
        public string Url { get; set; }
    }
}
