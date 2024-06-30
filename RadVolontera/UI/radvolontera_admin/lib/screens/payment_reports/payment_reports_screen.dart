import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/payment/payment.dart';
import 'package:radvolontera_admin/models/payment/payment_pdf_data.dart';
import 'package:radvolontera_admin/models/payment/payment_report.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/providers/payment_provider.dart';
import 'package:radvolontera_admin/screens/payments/payment_details_screen.dart';
import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart'; // Add this for opening files

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
  List<AccountModel>? studentsResult;
  String? selectedStudentValue;
  List<DropdownItem> dropdownItems = [
    DropdownItem(2024, '2024'),
    DropdownItem(2023, '2023'),
    DropdownItem(2022, '2022'),
    DropdownItem(2021, '2021'),
    DropdownItem(2020, '2020'),
    DropdownItem(2019, '2019'),
  ];

  @override
  void initState() {
    super.initState();
    _paymentProvider = context.read<PaymentProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;

  Future<void> _loadData() async {
    var data = await _paymentProvider.getPaymentReport();
    var students = await _accountProvider.getAll(filter: {'userTypes': 3});
    setState(() {
      result = data;
      studentsResult = students.result;
      selectedValue = "2024";
    });
  }

  void _showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void _hideLoader(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _handleDropdownChange() async {
    _showLoader(context);
    try {
      var filter = {
        'year': selectedValue,
        'studentId': selectedStudentValue
      };

      if (selectedStudentValue == null) {
        filter['studentId'] = null;
      }

      var data = await _paymentProvider.getPaymentReport(filter: filter);
      setState(() {
        result = data;
      });
    } finally {
      _hideLoader(context);
    }
  }

  Future<void> _downloadPdf() async {
    _showLoader(context);
    try {
      var filter = {
        'year': selectedValue,
        'studentId': selectedStudentValue
      };

      if (selectedStudentValue == null) {
        filter['studentId'] = null;
      }

      var paymentData = await _paymentProvider.getPdfData(filter: filter);


      final pdfGenerator = PdfReportGenerator();
      final pdfFile = await pdfGenerator.generatePdfReport(paymentData, int.parse(selectedValue!));

      final outputDir = await getTemporaryDirectory();
      final outputFile = File('${outputDir.path}/report.pdf');
      await outputFile.writeAsBytes(pdfFile);

      // Open the PDF file using the `open_file` package
      await OpenFile.open(outputFile.path);

      print('PDF generated: ${outputFile.path}');
    } finally {
      _hideLoader(context);
    }
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
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: selectedStudentValue,
              hint: Text('Select student'),
              onChanged: (newValue) async {
                setState(() {
                  selectedStudentValue = newValue;
                });
                await _handleDropdownChange();
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Students'),
                ),
                ...?studentsResult?.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.id.toString(),
                    child: Text('${item.firstName} ${item.lastName}'),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text('Select year'),
              onChanged: (newValue) async {
                setState(() {
                  selectedValue = newValue;
                });
                await _handleDropdownChange();
              },
              items: dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item.value.toString(),
                  child: Text(item.displayText),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _downloadPdf,
            child: Text("Download pdf"),
          ),
          SizedBox(width: 8),
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
            child: Text("Add new payment"),
          ),
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
                  color: Colors.green, // You can set the color based on your requirements
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
          backgroundColor: Colors.transparent,
          barGroups: generateBarChartGroups(),
          titlesData: FlTitlesData(),
          maxY: 1000,
        ),
      ),
    );
  }
}

class PdfReportGenerator {
  Future<Uint8List> generatePdfReport(
      PaymentPdfDataModel paymentData, int selectedYear) async {
    final pdf = pw.Document();
    final logoImage = await _loadImage('assets/images/logo.jpg');
    final currentDate = DateTime.now();
    final studentInfo = paymentData.student != null
        ? "Student: ${paymentData.student!.fullName}"
        : "All Students";
    final dateInfo = "Year: $selectedYear";
    final formattedDate =
        "${currentDate.day}.${currentDate.month}.${currentDate.year}";

    // Cover page
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(logoImage, width: 100, height: 100),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Payment Reports',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Text(dateInfo, style: pw.TextStyle(fontSize: 18), textAlign: pw.TextAlign.center),
                pw.Text(studentInfo, style: pw.TextStyle(fontSize: 18), textAlign: pw.TextAlign.center),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Generated on: $formattedDate',
                  style: pw.TextStyle(fontSize: 12),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Table page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return _buildTable(paymentData, selectedYear);
        },
      ),
    );

    return pdf.save();
  }

  Future<pw.ImageProvider> _loadImage(String path) async {
    final byteData = await rootBundle.load(path);
    final image = pw.MemoryImage(byteData.buffer.asUint8List());
    return image;
  }

  pw.Widget _buildTable(PaymentPdfDataModel paymentData, int selectedYear) {
    return pw.Table(
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        for (int i = 1; i <= 12; i++) i: pw.FlexColumnWidth(1),
      },
      border: pw.TableBorder.all(color: PdfColors.blue, width: 1),
      children: paymentData.student != null
          ? _buildStudentTable(paymentData.payments)
          : _buildAllStudentsTable(paymentData.payments),
    );
  }

  List<pw.TableRow> _buildStudentTable(List<PaymentModel> payments) {
    double totalForAllMonths = 0;

    final rows = <pw.TableRow>[
      pw.TableRow(
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Month', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Total Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ],
      ),
    ];

    for (int month = 1; month <= 12; month++) {
      final monthPayments = payments.where((p) => p.month == month).toList();
      final totalAmount = monthPayments.isNotEmpty
          ? monthPayments.map((p) => p.amount).reduce((a, b) => a + b)
          : 0.0;

      totalForAllMonths += totalAmount;
      final monthName = DateFormat.MMMM().format(DateTime(0, month));

      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(monthName)),
            pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('$totalAmount BAM')),
          ],
        ),
      );
    }

    rows.add(
      pw.TableRow(
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('$totalForAllMonths BAM', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ],
      ),
    );

    return rows;
  }

  List<pw.TableRow> _buildAllStudentsTable(List<PaymentModel> payments) {
    final rows = <pw.TableRow>[
      pw.TableRow(
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Student Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          for (int month = 1; month <= 12; month++)
          pw.Padding(padding: pw.EdgeInsets.all(2), child: pw.Text(DateFormat.MMMM().format(DateTime(0, month)).substring(0, 3), style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ],
      ),
    ];

    final students = payments.map((p) => p.student?.fullName ?? "").toSet().toList();
    double globalTotal = 0.0;

    for (final student in students) {
      final studentPayments = payments.where((p) => p.student?.fullName == student).toList();
      double studentTotal = 0.0;

      rows.add(
        pw.TableRow(
          children: [
            pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(student)),
            for (int month = 1; month <= 12; month++)
              pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(
                '${studentPayments.where((p) => p.month == month).map((p) => p.amount).fold(0, (a, b) => (a + b).toInt())} BAM',
                textAlign: pw.TextAlign.center,
              )),
            pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(
              '${studentPayments.map((p) => p.amount).fold(0, (a, b) => (a + b).toInt())} BAM',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            )),
          ],
        ),
      );

      globalTotal += studentPayments.map((p) => p.amount).fold(0, (a, b) => a + b);
    }

    rows.add(
      pw.TableRow(
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('Global Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          for (int month = 1; month <= 12; month++)
            pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(
              '${payments.where((p) => p.month == month).map((p) => p.amount).fold(0, (a, b) => (a + b).toInt())} BAM',
              textAlign: pw.TextAlign.center,
            )),
          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text('$globalTotal BAM', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        ],
      ),
    );

    return rows;
  }
}


