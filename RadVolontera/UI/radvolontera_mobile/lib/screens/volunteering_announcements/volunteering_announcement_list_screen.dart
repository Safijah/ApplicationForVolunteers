import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import 'package:radvolontera_mobile/models/status/status.dart';
import 'package:radvolontera_mobile/models/volunteering_announcement/volunteering_announcement.dart';
import 'package:radvolontera_mobile/providers/status_provider.dart';
import 'package:radvolontera_mobile/providers/volunteering_announcement_provider.dart';
import 'package:radvolontera_mobile/screens/volunteering_announcements/volunteering_announcement_details_screen.dart';

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
  String? selectedStatusValue;
  SearchResult<StatusModel>? statusResult;
 late StatusProvider _statusProvider;
  @override
  void initState() {
    super.initState();
    _volunteeringAnnouncementProvider = context.read<VolunteeringAnnouncementProvider>();
    _accountProvider = context.read<AccountProvider>();
_statusProvider = context.read<StatusProvider>();
    _loadData();
  }

  _loadData() async {
    try {
      currentUser = await _accountProvider.getCurrentUser();
      statusResult= await _statusProvider.get();
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
      title_widget: Text("Announcements"),
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              if (volunteeringAnnouncements != null && volunteeringAnnouncements!.isNotEmpty)
                _buildHeading('Volunteering Announcements'),
                _buildSearch(),
              _buildAnnouncements(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VolunteeringAnnouncementDetailsScreen()),
            ).then((_) => _loadData()); // Reload the data after adding a new announcement
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: DropdownButton<String>(
              value: selectedStatusValue,
              hint: Text('Select status'),
              onChanged: (newValue) async {
                setState(() {
                  selectedStatusValue = newValue;
                });

                var filter = {
                  'mentorId': this.currentUser.nameid,
                  'statusId': selectedStatusValue
                };

                // If "All" is selected, set studentId to null in the filter
                if (selectedStatusValue == null) {
                  filter['statusId'] = null;
                }

                var data =
                    await _volunteeringAnnouncementProvider.get(filter: filter);

                setState(() {
                  volunteeringAnnouncements = data.result;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null, // Use null value for "All" option
                  child: Text('All statuses'),
                ),
                ...?statusResult?.result.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.name.toString()),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
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
            subtitle: Text(volunteeringAnnouncement.notes ?? ""),
             trailing: Text(volunteeringAnnouncement.announcementStatus?.name ?? ""),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VolunteeringAnnouncementDetailsScreen(
                    volunteeringAnnouncementModel: volunteeringAnnouncement,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

 
