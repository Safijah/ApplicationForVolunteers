using RadVolontera.Models.Account;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.FITPasos
{
    public class FITPasos
    {
        public long Id { get; set; }
        public bool IsValid { get; set; }
        public string UserId { get; set; }
        public DateTime DatumIzdavanja { get; set; }
        public UserResponse User { get; set; }
    }
}
