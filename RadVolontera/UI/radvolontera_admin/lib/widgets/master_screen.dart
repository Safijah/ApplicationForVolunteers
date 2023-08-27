import 'package:flutter/material.dart';
import 'package:radvolontera_admin/main.dart';
import 'package:radvolontera_admin/screens/payments/payment_list.dart';
import 'package:radvolontera_admin/screens/reports/report_list_screen.dart';
import 'package:radvolontera_admin/screens/users/user_list_screen.dart';
import 'package:radvolontera_admin/utils/util.dart';

import '../screens/notifications/notification_list_screen.dart';
import '../screens/useful_links/useful_link_list_screen.dart';
import '../screens/volunteering_announcements/volunteering_announcement_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;
  MasterScreenWidget({this.child, this.title, this.title_widget, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget ?? Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.indigo, // Change the color of the drawer here
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.arrow_back,
                    color: Colors.white), // Add an icon to the ListTile
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle_sharp,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Users", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const UserListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Notifications",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const NotificationListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.link,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Useful links", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const UsefulLinkListScreen()),
                  );
                },
              ),
                    ListTile(
                leading: Icon(Icons.payments_outlined,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Payments", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const PaymentListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.volunteer_activism_sharp,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Volunteering Announcements", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const VolunteeringAnnouncementListcreen()),
                  );
                },
              ),
                 ListTile(
                leading: Icon(Icons.report_gmailerrorred,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Reports", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ReportListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Authorization.token = null;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: widget.child!,
    );
  }
}
