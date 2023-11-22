import 'package:flutter/material.dart';
import 'package:radvolontera_admin/main.dart';
import 'package:radvolontera_admin/screens/companies/company_list_screen.dart';
import 'package:radvolontera_admin/screens/payments/payment_list_screen.dart';
import 'package:radvolontera_admin/screens/reports/report_list_screen.dart';
import 'package:radvolontera_admin/screens/users/user_details_screen.dart';
import 'package:radvolontera_admin/screens/users/user_list_screen.dart';
import 'package:radvolontera_admin/utils/util.dart';

import '../screens/company_categories/company_category_list_screen.dart';
import '../screens/company_events/company_events_list_screen.dart';
import '../screens/dashboard/dashboard.dart';
import '../screens/notifications/notification_list_screen.dart';
import '../screens/payment_reports/payment_reports_screen.dart';
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
         actions: [
          // Profile icon in the AppBar
          IconButton(
              padding: EdgeInsets.only(right: 50.0),
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(user: null,),
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
                title: Text("Dashboard", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>  DashboardPage()),
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
                leading: Icon(Icons.payments_rounded,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Payments report", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const PaymentReportListScreen()),
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
                leading: Icon(Icons.category_rounded,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Company categories", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const CompanyCategoryListScreen()),
                  );
                },
              ),
               ListTile(
                leading: Icon(Icons.apartment_rounded,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Companies", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const CompanyListScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.event,
                    color: Colors.white), // Add an icon to the ListTile
                title:
                    Text("Company events", style: TextStyle(color: Colors.white)),
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
