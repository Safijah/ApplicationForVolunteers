import 'package:flutter/material.dart';
import 'package:radvolontera_mobile/main.dart';
import 'package:radvolontera_mobile/screens/annual_plan/annual_plan_list_screen.dart';
import 'package:radvolontera_mobile/screens/company_events/company_events_list_screen.dart';
import 'package:radvolontera_mobile/screens/home/home_screen.dart';
import 'package:radvolontera_mobile/screens/monitoring/monitoring_screen.dart';
import 'package:radvolontera_mobile/screens/reports/reports_list_screen.dart';
import 'package:radvolontera_mobile/screens/users/user_list_screen.dart';
import 'package:radvolontera_mobile/screens/users/user_profile_screen.dart';
import 'package:radvolontera_mobile/utils/util.dart';
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
            actions: [
      IconButton(
        icon: Icon(Icons.person),
        onPressed: () {
          // Navigate to the user profile screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(),
            ),
          );
        },
      ),
    ],
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
                leading: Icon(Icons.home,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Home", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>  HomePageScreen()),
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
                        builder: (context) => const VolunteeringAnnouncementListScreen()),
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
                leading: Icon(Icons.video_camera_front,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Monitoring", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const MonitoringListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.collections_bookmark_sharp,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Annual plans", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AnnualPlanListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.event,
                    color: Colors.white), // Add an icon to the ListTile
                title: Text("Company events", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const CompanyEventListScreen()),
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
