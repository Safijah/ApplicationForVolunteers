using RadVolontera.Models.Enums;
using RadVolontera.Services.Domain.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class Payment : BaseSoftDeleteEntity
    {
        public long Id { get; set; }
        public string Notes { get; set; }
        public double Amount { get; set; }
        public Month Month { get; set; }
        public  int Year { get; set; }
        public string StudentId { get; set; }
        public User Student { get; set; }
    }
}
