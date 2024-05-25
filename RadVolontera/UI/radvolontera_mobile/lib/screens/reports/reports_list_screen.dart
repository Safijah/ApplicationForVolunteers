import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/report/report.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import 'package:radvolontera_mobile/models/status/status.dart';
import 'package:radvolontera_mobile/providers/report_provider.dart';
import 'package:radvolontera_mobile/providers/status_provider.dart';
import 'package:radvolontera_mobile/screens/reports/report_details_screen.dart';

import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({Key? key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  late ReportProvider _reportProvider;
  List<ReportModel>? reports;
  late AccountProvider _accountProvider;
  dynamic currentUser = null;
  String? selectedStatusValue;
  SearchResult<StatusModel>? statusResult;
  late StatusProvider _statusProvider;

  @override
  void initState() {
    super.initState();
    _reportProvider = context.read<ReportProvider>();
    _accountProvider = context.read<AccountProvider>();
    _statusProvider = context.read<StatusProvider>();

    // Call your method here
    _loadData();
  }

  _loadData() async {
    try {
      currentUser = await _accountProvider.getCurrentUser();
      statusResult = await _statusProvider.get();
      var reportsData = await _reportProvider.getReports(currentUser.nameid);

      setState(() {
        reports = reportsData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Reports"),
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              if (reports != null && reports!.isNotEmpty)
                _buildHeading('Reports'),
              _buildSearch(),
              _buildReports(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: selectedStatusValue,
              hint: Text('Select status'),
              onChanged: (newValue) async {
                setState(() {
                  selectedStatusValue = newValue;
                });

                var filter = {
                  'mentorId': currentUser.nameid,
                  'statusId': selectedStatusValue
                };

                // If "All" is selected, set statusId to null in the filter
                if (selectedStatusValue == null) {
                  filter['statusId'] = null;
                }

                var data = await _reportProvider.get(filter: filter);

                setState(() {
                  reports = data.result;
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
          SizedBox(width: 8),
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

  Widget _buildReports() {
    if (reports == null || reports!.isEmpty) {
      // If there are no reports, display a message in the center of the page
      return Center(
        child: Text(
          'No reports data',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: reports!.map((ReportModel report) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(report.goal ?? ""),
            subtitle: Text(report.goal ?? ""),
            trailing: Text(report.status?.name ?? ""),
             onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReportDetailsScreen(
                    reportModel: report,
                    announcementId: 0,
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
