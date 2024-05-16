import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/volunteering_announcement/volunteering_announcement.dart';
import 'package:radvolontera_mobile/providers/volunteering_announcement_provider.dart';

import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class VolunteeringAnnouncementListScreen extends StatefulWidget {
  const VolunteeringAnnouncementListScreen({Key? key});

  @override
  State<VolunteeringAnnouncementListScreen> createState() => _VolunteeringAnnouncementListScreenState();
}

class _VolunteeringAnnouncementListScreenState extends State<VolunteeringAnnouncementListScreen> {
  late VolunteeringAnnouncementProvider _volunteeringAnnouncementProvider;
  List<VolunteeringAnnouncementModel>? volunteeringAnnouncements;
  late AccountProvider _accountProvider;
  dynamic currentUser = null;
  @override
  void initState() {
    super.initState();
    _volunteeringAnnouncementProvider = context.read<VolunteeringAnnouncementProvider>();
 _accountProvider = context.read<AccountProvider>();

    // Call your method here
    _loadData();
  }

  _loadData() async {
    try {
       currentUser = await _accountProvider.getCurrentUser();
      var volunteeringAnnouncementsData = await _volunteeringAnnouncementProvider.getAnnoucments(this.currentUser.nameid);

      setState(() {
        volunteeringAnnouncements = volunteeringAnnouncementsData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Text("Announcements"),
      child: Container(
        child: Column(
          children: [
            if (volunteeringAnnouncements != null && volunteeringAnnouncements!.isNotEmpty)
              _buildHeading('Volunteering Announcements'),
            _buildAnnouncements(),
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

 Widget _buildAnnouncements() {
  if (volunteeringAnnouncements == null || volunteeringAnnouncements!.isEmpty) {
    // If there are no announcements, display a message in the center of the page
    return Center(
      child: Text(
        'No announcements data',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  return Column(
    children: volunteeringAnnouncements!.map((VolunteeringAnnouncementModel volunteeringAnnouncement) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(volunteeringAnnouncement.place ?? ""),
          subtitle: Text(volunteeringAnnouncement.place ?? ""),
        ),
      );
    }).toList(),
  );
}


}
