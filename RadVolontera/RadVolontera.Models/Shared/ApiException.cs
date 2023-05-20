using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Shared
{
    public class ApiException : Exception
    {
        public HttpStatusCode? StatusCode { get; set; }
        public string ErrorMessage { get; set; }
        public ApiException(string message, HttpStatusCode statusCode)
        {
            StatusCode = statusCode;
            ErrorMessage = message;
        }
    }
}
