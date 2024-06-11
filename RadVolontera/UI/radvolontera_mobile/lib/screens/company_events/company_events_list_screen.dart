import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/company/company.dart';
import 'package:radvolontera_mobile/models/company_event/company_event.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/company_event_provider.dart';
import 'package:radvolontera_mobile/screens/company_events/company_events_details_screen.dart';

import '../../models/search_result.dart';
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
  SearchResult<CompanyEventModel>? result;
  SearchResult<CompanyModel>? companyResult;
  String? selectedValue; // variable to store the selected value
  dynamic currentUser = null;
  bool showRegisteredOnly = false; 
  late AccountProvider _accountProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _companyEventProvider = context.read<CompanyEventProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  _loadData() async {
    currentUser = await _accountProvider.getCurrentUser();
    var data = await _companyEventProvider.get();
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

   Future<void> _filterRegisteredEvents(bool value) async {
      showRegisteredOnly = value;
      var data;
      if(value){
       data = await _companyEventProvider.get(filter:{
        'mentorId':this.currentUser.nameid,
        'registered':this.showRegisteredOnly
      });
      } else{
         data = await _companyEventProvider.get();
      }
    setState(() {
      result = data;
    });
  }

   Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: showRegisteredOnly,
            onChanged: (value) {
              _filterRegisteredEvents(value ?? false);
            },
          ),
          Text("Show registered events only"),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: result?.result.length ?? 0,
        itemBuilder: (context, index) {
          var event = result!.result[index];
          return ListTile(
            title: Text(event.eventName ?? ""),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Location: ${event.location ?? ""}"),
                Text("Company: ${event.company?.name ?? ""}"),
                Text("Time: ${event.time?? ""}"),
                Text("Date: ${DateFormat('dd.MM.yyyy').format(event.eventDate!)}"),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CompanyEventDetailsScreen(companyEvent: event),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
