using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Database
{
    public class FITPasos 
    {
        public long Id { get; set; }
        public DateTime DatumIzdavanja { get; set; }
        public bool IsValid { get; set; }
        public string UserId { get; set; }
        public  User User { get; set; }
    }
}
