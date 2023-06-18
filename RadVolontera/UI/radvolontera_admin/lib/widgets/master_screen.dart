import 'package:flutter/material.dart';
import 'package:radvolontera_admin/screens/notification/notification_details_screen.dart';

import '../screens/notification/notification_list_screen.dart';
class MasterScreenWidget extends StatefulWidget {
Widget ? child ;
String ? title ;
Widget ? title_widget;
   MasterScreenWidget({this.child,this.title,this.title_widget,super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:widget.title_widget ?? Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Back"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Notifications"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const NotificationListScreen(),));
              },
            ),
            ListTile(
              title: Text("Notification details"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const NotificationDetailsWidget(),));
              },
            )
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}