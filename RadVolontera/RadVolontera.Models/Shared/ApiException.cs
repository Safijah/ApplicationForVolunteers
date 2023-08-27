using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Shared
{
    public class ApiException : CustomException
    {
        public ApiException(string message, HttpStatusCode code)
            :base(message, code) 
        {
            
        }
    }
}
