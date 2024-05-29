import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/useful_links/useful_link.dart';
import 'package:radvolontera_mobile/providers/useful_link_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/notification/notification.dart';
import '../../models/search_result.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/master_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late NotificationProvider _notificationProvider;
  late UsefulLinkProvider _usefulLinkProvider;
  List<NotificationModel>? notifications;
  List<UsefulLinkModel>? usefulLinks;

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    _usefulLinkProvider = context.read<UsefulLinkProvider>();
    _loadData();
  }

  _loadData() async {
    try {
      var notificationsData = await _notificationProvider.get();
      var linksData = await _usefulLinkProvider.get();

      setState(() {
        notifications = notificationsData.result;
        usefulLinks = linksData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Home"),
      child: Container(
        child: Column(
          children: [
            if (notifications != null && notifications!.isNotEmpty)
              _buildHeading('Notifications'),
            _buildNotifications(),
            if (usefulLinks != null && usefulLinks!.isNotEmpty)
              _buildHeading('Useful Links'),
            _buildUsefulLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return Column(
      children: (notifications ?? []).map((NotificationModel notification) {
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

  Widget _buildUsefulLinks() {
    return Column(
      children: (usefulLinks ?? []).map((UsefulLinkModel link) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: InkWell(
              onTap: () async {
                var url = link.urlLink ?? '';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  // Handle the case when the URL can't be launched
                  print('Could not launch $url');
                }
              },
              child: Text(
                link.name ?? '',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            subtitle: Text(link.urlLink ?? ''),
          ),
        );
      }).toList(),
    );
  }
}
