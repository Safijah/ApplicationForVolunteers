import 'package:flutter/material.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class NotificationDetailsWidget extends StatefulWidget {
  const NotificationDetailsWidget({super.key});

  @override
  State<NotificationDetailsWidget> createState() => _NotificationDetailsWidgetState();
}

class _NotificationDetailsWidgetState extends State<NotificationDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Notification details"),
      child: Text("Test"),
    );
  }
}