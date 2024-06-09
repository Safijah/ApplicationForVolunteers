

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/report/report.dart';
import 'package:radvolontera_admin/providers/report_provider.dart';
import 'package:radvolontera_admin/screens/reports/report_details_screen.dart';

import '../../models/account/account.dart';
import '../../models/search_result.dart';
import '../../models/status/status.dart';
import '../../providers/account_provider.dart';
import '../../providers/status_provider.dart';
import '../../widgets/master_screen.dart';
import '../payments/payment_details_screen.dart';
import '../users/user_details_screen.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() =>
      _ReportListScreenState();
}


class _ReportListScreenState
    extends State<ReportListScreen> {
  late ReportProvider _reportProvider;
  late AccountProvider _accountProvider;
  late StatusProvider _statusProvider;
  SearchResult<ReportModel>? result;
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
    _reportProvider =
        context.read<ReportProvider>();
    _accountProvider = context.read<AccountProvider>();
    _statusProvider = context.read<StatusProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _reportProvider.get();
    mentorsResult = await _accountProvider.getAll(filter: {'userTypes': 2});
    statusResult= await _statusProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Report list"),
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
                    await _reportProvider.get(filter: filter);

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
                    await _reportProvider.get(filter: filter);

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
            width: 8,)
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
        ReportModel report = result!.result[index];
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text('${report.mentor != null ? "${report.mentor!.firstName} ${report.mentor!.lastName}" : ""}'),
            subtitle: Text(report.themes ?? ""),
            trailing: Text(report.status?.name ?? ""),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReportDetailsScreen(
                    reportModel: report,
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
