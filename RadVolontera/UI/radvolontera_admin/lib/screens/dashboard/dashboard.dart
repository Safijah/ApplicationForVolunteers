import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/dashboard_data.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/providers/notification_provider.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

import '../../models/notification/notification.dart';
import '../../models/search_result.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
    late NotificationProvider _notificationProvider;
    late AccountProvider _accountProvider;
     SearchResult<NotificationModel> ? result;
     DashboardModel? dashboardModel;
      @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

 @override
  void initState() {
    super.initState();
     _notificationProvider = context.read<NotificationProvider>();
     _accountProvider = context.read<AccountProvider>();
    // Call your method here
    _loadData();
  }

    _loadData() async {
     var data = await _notificationProvider.get();
     dashboardModel = await _accountProvider.getDashboardData();
      setState(() {
                  result = data;
                });
  }
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Dashboard"),
      child: _buildDashboardContent(),
    );
  }

  Widget _buildDashboardContent() {

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            return _buildLargeLayout(
              dashboardModel?.adminCount ?? 0,
              dashboardModel?.studentCount ?? 0,
              dashboardModel?.mentorCount ?? 0,
            );
          } else {
            return _buildSmallLayout(
              dashboardModel?.adminCount ?? 0,
              dashboardModel?.studentCount ?? 0,
              dashboardModel?.mentorCount ?? 0,
            );
          }
        },
      ),
    );
  }

  Widget _buildLargeLayout(
    int numberOfAdmins,
    int numberOfStudents,
    int numberOfMentors,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildNotificationCards(),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Distribution',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildUserChart(
                numberOfAdmins: numberOfAdmins,
                numberOfStudents: numberOfStudents,
                numberOfMentors: numberOfMentors,
              ),
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUserCard('Admins', numberOfAdmins, Colors.green),
                  _buildUserCard('Students', numberOfStudents, Colors.blue),
                  _buildUserCard('Mentors', numberOfMentors, Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallLayout(
    int numberOfAdmins,
    int numberOfStudents,
    int numberOfMentors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _buildNotificationCards(),
        SizedBox(height: 20),
        Text(
          'User Distribution',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        _buildUserChart(
          numberOfAdmins: numberOfAdmins,
          numberOfStudents: numberOfStudents,
          numberOfMentors: numberOfMentors,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildUserCard('Admins', numberOfAdmins, Colors.green),
            _buildUserCard('Students', numberOfStudents, Colors.blue),
            _buildUserCard('Mentors', numberOfMentors, Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildUserCard(String title, int count, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserChart({
    required int numberOfAdmins,
    required int numberOfStudents,
    required int numberOfMentors,
  }) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          groupsSpace: 20,
          borderData: FlBorderData(show: false),
          backgroundColor: Colors.transparent, // Remove background color
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: numberOfAdmins.toDouble(), color: Colors.green)
            ], showingTooltipIndicators: [0]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: numberOfStudents.toDouble(), color: Colors.blue)
            ], showingTooltipIndicators: [0]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: numberOfMentors.toDouble(), color: Colors.orange)
            ], showingTooltipIndicators: [0]),
          ],
          titlesData: FlTitlesData(show: false),
          maxY: numberOfStudents.toDouble() + 10, // Adjust this value as needed
        ),
      ),
    );
  }

Widget _buildNotificationCards() {
  return Column(
    children: (result?.result?.take(5) ?? []).map((NotificationModel notification) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(notification.heading ?? ''),
          subtitle: Text(notification.content ?? ''),
        ),
      );
    }).toList(),
  );
}
}
