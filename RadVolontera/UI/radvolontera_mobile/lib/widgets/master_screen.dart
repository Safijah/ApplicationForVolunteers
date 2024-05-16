import 'package:flutter/material.dart';
import 'package:radvolontera_mobile/main.dart';
import 'package:radvolontera_mobile/screens/home/home_screen.dart';
import 'package:radvolontera_mobile/screens/volunteering_announcements/volunteering_announcement_list_screen.dart';
import 'package:radvolontera_mobile/screens/reports/reports_list_screen.dart';
import 'package:radvolontera_mobile/utils/util.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;
  final Widget? titleWidget;

  MasterScreenWidget({Key? key, this.child, this.title, this.titleWidget})
      : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePageScreen(),
    VolunteeringAnnouncementListScreen(),
    ReportListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.titleWidget ?? Text(widget.title ?? ""),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              navigateTo(HomePageScreen());
            },
          ),
        ],
      ),
      drawer: null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_sharp),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_gmailerrorred),
            label: 'Reports',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  void handleLogout() {
    Authorization.token = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
