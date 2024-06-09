import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/monitoring/monitoring.dart';
import 'package:radvolontera_admin/models/search_result.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/providers/monitoring_provider.dart';
import 'package:radvolontera_admin/screens/monitoring/monitoring_details_screen.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class MonitoringListScreen extends StatefulWidget {
  const MonitoringListScreen({super.key});

  @override
  State<MonitoringListScreen> createState() => _MonitoringListScreenState();
}

class _MonitoringListScreenState extends State<MonitoringListScreen> {
  late AccountProvider _accountProvider;
  SearchResult<MonitoringModel>? result;
  String? selectedMentorValue; // variable to store the selected value
  late MonitoringProvider _monitoringProvider;
  SearchResult<AccountModel>? mentorResult;
  bool forToday = false; // Variable to store the state of the checkbox

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
    _monitoringProvider = context.read<MonitoringProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _monitoringProvider.get();
    mentorResult = await _accountProvider.getAll(filter: {
      'userTypes': 2
    });
    setState(() {
      result = data;
    });
  }

  _applyFilters() async {
    var filter = {
      'mentorId': selectedMentorValue,
      'forToday': forToday, // Apply the checkbox filter
    };

    // If "All" is selected, set mentorId to null in the filter
    if (selectedMentorValue == null) {
      filter['mentorId'] = null;
    }

    var data = await _monitoringProvider.get(filter: filter);

    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Monitoring list"),
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
              onChanged: (newValue) {
                setState(() {
                  selectedMentorValue = newValue;
                });
                _applyFilters();
              },
              items: [
                DropdownMenuItem<String>(
                  value: null, // Use null value for "All" option
                  child: Text('All mentors'),
                ),
                ...?mentorResult?.result.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text(item.fullName ?? ""),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            children: [
              Checkbox(
                value: forToday,
                onChanged: (bool? value) {
                  setState(() {
                    forToday = value ?? false;
                  });
                  _applyFilters();
                },
              ),
              Text('For Today'),
            ],
          ),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MonitoringDetailsScreen(
                      monitoring: null,
                    ),
                  ),
                );
              },
              child: Text("Add new"))
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Background color for the table
          child: DataTable(
            columnSpacing: 24.0, // Adjust column spacing as needed
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo), // Header row color
            dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white), // Row color
            columns: [
              DataColumn(
                label: Text(
                  'Notes',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Mentor',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
              DataColumn(
                label: Text(
                  'Date',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ],
            rows: result?.result
                .map((MonitoringModel e) => DataRow(
                      onSelectChanged: (selected) => {
                        if (selected == true)
                          {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MonitoringDetailsScreen(
                                  monitoring: e,
                                ),
                              ),
                            )
                          }
                      },
                      cells: [
                        DataCell(Text(e.notes ?? "")),
                        DataCell(Text(e.mentor != null ? e.mentor!.fullName! : "")),
                        DataCell(Text(e.date != null ? DateFormat('dd.MM.yyyy').format(e.date) : "")),
                      ],
                    ))
                .toList() ??
                [],
          ),
        ),
      ),
    );
  }
}
