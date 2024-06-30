import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/monitoring/monitoring.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import 'package:radvolontera_mobile/providers/monitoring_provider.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class MonitoringListScreen extends StatefulWidget {
  const MonitoringListScreen({Key? key});

  @override
  State<MonitoringListScreen> createState() => _MonitoringListScreenState();
}

class _MonitoringListScreenState extends State<MonitoringListScreen> {
  late MonitoringProvider _monitoringProvider;
  List<MonitoringModel>? monitoring;
  late AccountProvider _accountProvider;
  dynamic currentUser = null;
   bool forToday = false; 
  @override
  void initState() {
    super.initState();
    _monitoringProvider = context.read<MonitoringProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  _loadData() async {
    try {
      currentUser = await _accountProvider.getCurrentUser();

      var monitoringData = await _monitoringProvider.get(filter:{'mentorId':currentUser.nameid});

      setState(() {
        monitoring = monitoringData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

 _applyFilters() async {
    var filter = {
      'mentorId': this.currentUser.nameid,
      'forToday': forToday, // Apply the checkbox filter
    };

    var data = await _monitoringProvider.get(filter: filter);

    setState(() {
      monitoring = data.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Monitoring"),
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              if (monitoring != null && monitoring!.isNotEmpty)
                _buildHeading('Monitoring'),
                _buildSearch(),
              _buildMonitoring(),
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
        Expanded(
          child: Center(
            child: Column(
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
          ),
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

  Widget _buildMonitoring() {
    if (monitoring == null || monitoring!.isEmpty) {
      return Center(
        child: Text(
          'No monitorings data',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: monitoring!.map((MonitoringModel monitoring) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(monitoring.notes ?? ""),
            subtitle: Text(monitoring.url ?? ""),
             onTap: () {
            },
          ),
        );
      }).toList(),
    );
  }
}

 
