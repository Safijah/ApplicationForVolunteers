import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/payment/payment.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/providers/payment_provider.dart';
import 'package:radvolontera_admin/screens/payments/payment_details_screen.dart';
import 'package:radvolontera_admin/screens/users/user_details_screen.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';
import '../notifications/notification_details_screen.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  late PaymentProvider _paymentProvider;
  late AccountProvider _accountProvider;
  SearchResult<PaymentModel>? result;
  TextEditingController _nameController = new TextEditingController();
  String? selectedValue; // variable to store the selected value
  SearchResult<AccountModel>? studentsResult;
  String? selectedStudentValue;
  List<DropdownItem> dropdownItems = [
    DropdownItem(0, 'All'),
    DropdownItem(1, 'January'),
    DropdownItem(2, 'February'),
    DropdownItem(3, 'March'),
    DropdownItem(4, 'April'),
    DropdownItem(5, 'May'),
    DropdownItem(6, 'June'),
    DropdownItem(7, 'July'),
    DropdownItem(8, 'August'),
    DropdownItem(9, 'September'),
    DropdownItem(10, 'October'),
    DropdownItem(11, 'November'),
    DropdownItem(12, 'December'),
  ];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _paymentProvider = context.read<PaymentProvider>();
    _accountProvider = context.read<AccountProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _paymentProvider.get();
    studentsResult =  await _accountProvider.getAll(filter: {
                  'userTypes': 3 
                });
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Payment list"),
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
    value: selectedStudentValue,
    hint: Text('Select student'),
    onChanged: (newValue) async {
      setState(() {
        selectedStudentValue = newValue;
      });

      var filter = {
        'month': selectedValue,
        'studentId': selectedStudentValue
      };

      // If "All" is selected, set studentId to null in the filter
      if (selectedStudentValue == null) {
        filter['studentId'] = null;
      }

      var data = await _paymentProvider.get(filter: filter);

      setState(() {
        result = data;
      });
    },
    items: [
      DropdownMenuItem<String>(
        value: null, // Use null value for "All" option
        child: Text('All Students'),
      ),
      ...?studentsResult?.result.map((item) {
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
              child: // list of dropdown items
                  DropdownButton<String>(
            value: selectedValue,
            hint: Text('Select month'), // optional hint text
            onChanged: (newValue) async {
              setState(() {
                selectedValue = newValue; // update the selected value
              });

              var data = await _paymentProvider.get(filter: {
                'month': selectedValue,
                'studentId': selectedStudentValue
              });

              setState(() {
                result = data;
              });
            },
            items: dropdownItems.map((item) {
              return DropdownMenuItem<String>(
                value: item.value.toString(),
                child: Text(item.displayText),
              );
            }).toList(),
          )),
          SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentDetailsScreen(
                      payment: null,
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
          headingRowColor: WidgetStateColor.resolveWith((states) => Colors.indigo), // Header row color
          dataRowColor: WidgetStateColor.resolveWith((states) => Colors.white), // Row color
          columns: [
            DataColumn(
              label: Text(
                'Notes',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Month',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Year',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'User',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
          ],
          rows: result?.result
              .map((PaymentModel e) => DataRow(
                    onSelectChanged: (selected) => {
                      if (selected == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaymentDetailsScreen(
                              payment: e,
                            ),
                          ),
                        )
                      }
                    },
                    cells: [
                      DataCell(Text(e.notes ?? "")),
                      DataCell(Text(e.amount.toString())),
                      DataCell(Text(e.monthName ?? "")),
                      DataCell(Text(e.year != null ? e.year.toString() : "")),
                      DataCell(Text(e.student != null ? '${e.student!.firstName} ${e.student!.lastName}' : '')),
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
