import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/status/status.dart';
import 'package:radvolontera_admin/models/volunteering_announcement/volunteering_announcement.dart';
import 'package:radvolontera_admin/providers/status_provider.dart';
import 'package:radvolontera_admin/providers/volunteering_announcement_provider.dart';
import 'package:radvolontera_admin/screens/volunteering_announcements/volunteering_announcement_details_screen.dart';

import '../../models/account/account.dart';
import '../../models/search_result.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class VolunteeringAnnouncementListcreen extends StatefulWidget {
  const VolunteeringAnnouncementListcreen({super.key});

  @override
  State<VolunteeringAnnouncementListcreen> createState() =>
      _VolunteeringAnnouncementListcreenState();
}


class _VolunteeringAnnouncementListcreenState
    extends State<VolunteeringAnnouncementListcreen> {
  late VolunteeringAnnouncementProvider _volunteeringAnnouncementProvider;
  late AccountProvider _accountProvider;
  late StatusProvider _statusProvider;
  SearchResult<VolunteeringAnnouncementModel>? result;
  String? selectedMentorValue; // variable to store the selected value
  SearchResult<AccountModel>? mentorsResult;
  SearchResult<StatusModel>? statusResult;
  String? selectedStatusValue;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _volunteeringAnnouncementProvider =
        context.read<VolunteeringAnnouncementProvider>();
    _accountProvider = context.read<AccountProvider>();
    _statusProvider = context.read<StatusProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _volunteeringAnnouncementProvider.get();
    mentorsResult = await _accountProvider.getAll(filter: {'userTypes': 2});
    statusResult= await _statusProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Volunteering announcement list"),
      child: Container(
        child: Column(children: [_buildSearch(), _buildDataListView()]),
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
              value: selectedMentorValue,
              hint: Text('Select mentor'),
              onChanged: (newValue) async {
                setState(() {
                  selectedMentorValue = newValue;
                });

                var filter = {
                  'mentorId': selectedMentorValue,
                  'statusId': selectedStatusValue
                };

                // If "All" is selected, set studentId to null in the filter
                if (selectedMentorValue == null) {
                  filter['mentorId'] = null;
                }

                var data =
                    await _volunteeringAnnouncementProvider.get(filter: filter);

                setState(() {
                  result = data;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: null, // Use null value for "All" option
                  child: Text('All mentors'),
                ),
                ...?mentorsResult?.result.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text('${item.firstName} ${item.lastName}'),
                  );
                }).toList(),
              ],
            ),
          ),
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
                  'mentorId': selectedMentorValue,
                  'statusId': selectedStatusValue
                };

                // If "All" is selected, set studentId to null in the filter
                if (selectedStatusValue == null) {
                  filter['statusId'] = null;
                }

                var data =
                    await _volunteeringAnnouncementProvider.get(filter: filter);

                setState(() {
                  result = data;
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





Widget _buildDataListView() {
  if (result?.result == null || result!.result.isEmpty) {
    return Center(
      child: Text("No data available."),
    );
  }

  return Expanded(
    child: ListView.builder(
      itemCount: result!.result.length,
      itemBuilder: (context, index) {
        VolunteeringAnnouncementModel announcement = result!.result[index];
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text('${announcement.mentor != null ? "${announcement.mentor!.firstName} ${announcement.mentor!.lastName}" : ""}'),
            subtitle: Text('${announcement.notes ?? ""}, ${announcement.place ?? ""}'),
            trailing: Text(announcement.announcementStatus?.name ?? ""),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VolunteeringAnnouncementDetailsScreen(
                    volunteeringAnnouncementModel: announcement,
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
    }
