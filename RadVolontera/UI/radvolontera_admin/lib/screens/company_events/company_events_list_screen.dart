

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/company/company.dart';
import 'package:radvolontera_admin/models/compnay_event/company_event.dart';
import 'package:radvolontera_admin/providers/company_event_provider.dart';
import 'package:radvolontera_admin/screens/company_events/company_events_details_screen.dart';

import '../../models/search_result.dart';
import '../../providers/company_provider.dart';
import '../../widgets/master_screen.dart';

class CompanyEventListScreen extends StatefulWidget {
  const CompanyEventListScreen({super.key});

  @override
  State<CompanyEventListScreen> createState() => _UserListScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _UserListScreenState extends State<CompanyEventListScreen> {
  late CompanyEventProvider _companyEventProvider;
  late CompanyProvider _companyProvider;
  SearchResult<CompanyEventModel>? result;
  SearchResult<CompanyModel>? companyResult;
  String? selectedValue; // variable to store the selected value
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _companyEventProvider = context.read<CompanyEventProvider>();
    _companyProvider = context.read<CompanyProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _companyEventProvider.get();
    companyResult = await _companyProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Company event list"),
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
    value: selectedValue,
    hint: Text('Select company'),
    onChanged: (newValue) async {
      setState(() {
        selectedValue = newValue;
      });

      var filter = {
        'companyId': selectedValue,
      };

      // If "All" is selected, set studentId to null in the filter
      if (selectedValue == null) {
        filter['companyId'] = null;
      }

      var data = await _companyEventProvider.get(filter: filter);

      setState(() {
        result = data;
      });
    },
    items: [
      DropdownMenuItem<String>(
        value: null, // Use null value for "All" option
        child: Text('All companies'),
      ),
      ...?companyResult?.result.map((item) {
        return DropdownMenuItem<String>(
          value: item.id.toString(),
          child: Text(item.name ?? ""),
        );
      }).toList(),
    ],
  ),
),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CompanyEventDetailsScreen(
                      companyEvent: null,
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
          columns: [
            DataColumn(
              label: Text(
                'Event name',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Location',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Company',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Time',
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
                  .map((CompanyEventModel e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CompanyEventDetailsScreen(companyEvent: e),
                                      ),
                                    ),
                                  }
                              },
                          cells: [
                            DataCell(Text(e.eventName ?? "")),
                            DataCell(Text(e.location ?? "")),
                            DataCell(Text(e.company?.name ?? "")),
                            DataCell(Text(e.time.toString() ?? "")),
                            DataCell(Text(DateFormat('dd.MM.yyyy').format(e.eventDate!))),
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