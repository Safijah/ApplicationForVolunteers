import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/report/report.dart';
import 'package:radvolontera_mobile/providers/report_provider.dart';

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
  @override
  void initState() {
    super.initState();
    _reportProvider = context.read<ReportProvider>();
 _accountProvider = context.read<AccountProvider>();

    // Call your method here
    _loadData();
  }

  _loadData() async {
    try {
       currentUser = await _accountProvider.getCurrentUser();
      var reportsData = await _reportProvider.getReports(this.currentUser.nameid);

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
       titleWidget: Text("Reports"),
      child: Container(
        child: Column(
          children: [
            if (reports != null && reports!.isNotEmpty)
              _buildHeading('Reports'),
            _buildReports(),
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
        ),
      );
    }).toList(),
  );
}


}
