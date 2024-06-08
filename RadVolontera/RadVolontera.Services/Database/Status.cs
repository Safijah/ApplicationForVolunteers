 using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class Status : BaseEntity
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public ICollection<VolunteeringAnnouncement> VolunteeringAnnouncements { get; set; }
        public ICollection<Report> Reports { get; set; }
        public ICollection<AnnualPlan> AnnualPlans { get; set; }
    }
}
