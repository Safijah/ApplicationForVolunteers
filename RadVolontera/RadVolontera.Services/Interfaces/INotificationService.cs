using RadVolontera.Models.Filters;
using RadVolontera.Models.Notification;
using RadVolontera.Models.Payment;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RadVolontera.Services.Interfaces
{
    public  interface INotificationService : ICRUDService<Models.Notification.Notification, NotificationSearchObject, NotificationRequest, NotificationRequest, long>
    {
    }
}
