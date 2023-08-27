using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Models.Shared
{
    public  class CustomException : Exception
    {
        public HttpStatusCode? StatusCode { get; set; }
        public string ErrorMessage { get; set; }
        public CustomException(string message, HttpStatusCode statusCode = HttpStatusCode.InternalServerError)
            :base(message)
        {
            StatusCode = statusCode;
            ErrorMessage = message;
        }
    }
}
