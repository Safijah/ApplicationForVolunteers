import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/payment/payment.dart';
import 'package:radvolontera_admin/models/payment/payment_report.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/providers/payment_provider.dart';
import 'package:radvolontera_admin/screens/payments/payment_details_screen.dart';
import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';

class PaymentReportListScreen extends StatefulWidget {
  const PaymentReportListScreen({super.key});
  List<Color> get availableColors => const <Color>[
        Colors.purple,
        Colors.yellow,
        Colors.blue,
        Colors.orange,
        Colors.pink,
        Colors.red,
      ];
  static Color barBackgroundColor = Colors.white.withOpacity(0.3);
  final Color barColor = Colors.white;
  final Color touchedBarColor = Colors.green;
  @override
  State<PaymentReportListScreen> createState() =>
      _PaymentReportListScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _PaymentReportListScreenState extends State<PaymentReportListScreen> {
  late PaymentProvider _paymentProvider;
  late AccountProvider _accountProvider;
  List<PaymentReportModel>? result;
  String? selectedValue; // variable to store the selected value
  SearchResult<AccountModel>? studentsResult;
  String? selectedStudentValue;
  List<DropdownItem> dropdownItems = [
    DropdownItem(2023, '2023'),
    DropdownItem(2022, '2022'),
    DropdownItem(2021, '2021'),
    DropdownItem(2020, '2020'),
    DropdownItem(2019, '2019'),
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

  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;
  _loadData() async {
    var data = await _paymentProvider.getPaymentReport();
    studentsResult = await _accountProvider.get(filter: {'userTypes': 3});
    selectedValue = "2023";
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Payment report"),
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
                  'year': selectedValue,
                  'studentId': selectedStudentValue
                };

                // If "All" is selected, set studentId to null in the filter
                if (selectedStudentValue == null) {
                  filter['studentId'] = null;
                }
                // If "All" is selected, set studentId to null in the filter

                var data =
                    await _paymentProvider.getPaymentReport(filter: filter);

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
            hint: Text('Select year'), // optional hint text
            onChanged: (newValue) async {
              setState(() {
                selectedValue = newValue; // update the selected value
              });
              var filter = {
                'year': selectedValue,
                'studentId': selectedStudentValue
              };

              var data = await _paymentProvider.getPaymentReport(filter: filter);

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
          ElevatedButton(
              onPressed: () async {
              
              },
              child: Text("Download pdf")),
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
    List<BarChartGroupData> generateBarChartGroups() {
      List<BarChartGroupData> barGroups = [];
      if (result != null) {
        for (int i = 0; i < result!.length; i++) {
          barGroups.add(
            BarChartGroupData(
              x: result![i].month!,
              barRods: [
                BarChartRodData(
                  toY: result![i].amount!, // Use your data here
                  color: Colors
                      .green, // You can set the color based on your requirements
                ),
              ],
              showingTooltipIndicators: [0],
            ),
          );
        }
      }

      return barGroups;
    }

    return Container(
      height: 500,
      child: BarChart(
        BarChartData(
          groupsSpace: 20,
          borderData: FlBorderData(show: false),
          backgroundColor: Colors.transparent, // Remove background color
          barGroups: generateBarChartGroups(), // Use the generated barGroups
          titlesData: FlTitlesData(),
          maxY: 1000, // Adjust this value as needed
        ),
      ),
    );
  }
}
