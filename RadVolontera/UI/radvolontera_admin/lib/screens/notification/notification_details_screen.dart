import 'package:flutter/material.dart';
import 'package:radvolontera_admin/models/notification/notification.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class NotificationDetailsWidget extends StatefulWidget {
    NotificationModel ? notificationModel;
   NotificationDetailsWidget({Key? key, this.notificationModel}) : super(key: key);

  @override
  State<NotificationDetailsWidget> createState() => _NotificationDetailsWidgetState();
}

class _NotificationDetailsWidgetState extends State<NotificationDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
       child: Text("Notification details!"),
      title: this.widget.notificationModel?.heading ?? "Notification details",
    );
  }
}