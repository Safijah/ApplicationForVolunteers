
import 'package:radvolontera_admin/models/notification/notification.dart';

import 'base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel>{
 NotificationProvider(): super("Notification");
      
    @override
  NotificationModel fromJson(data) {
    // TODO: implement fromJson
    return NotificationModel.fromJson(data);
  } 
}