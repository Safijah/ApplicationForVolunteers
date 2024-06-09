import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/annual_plan/annual_plan.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/annual_plan_provider.dart';
import 'package:radvolontera_mobile/screens/annual_plan/annual_plan_details.dart';
import 'package:radvolontera_mobile/screens/users/user_profile_screen.dart';
import 'package:radvolontera_mobile/widgets/master_screen.dart';


class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class AnnualPlanListScreen extends StatefulWidget {
  const AnnualPlanListScreen({super.key});

  @override
  State<AnnualPlanListScreen> createState() =>
      _AnnualPlanListScreenState();
}

List<DropdownItem> dropdownItems = [
  DropdownItem(2024, '2024'),
  DropdownItem(2023, '2025'),
  DropdownItem(2022, '2026'),
  DropdownItem(2021, '2027'),
  DropdownItem(2020, '2028'),
  DropdownItem(2019, '2029'),
];

class _AnnualPlanListScreenState
    extends State<AnnualPlanListScreen> {
  late AnnualPlanProvider _annualPlanProvider;
  late AccountProvider _accountProvider;
  SearchResult<AnnualPlanModel>? result;
  String? selectedValue;
  dynamic currentUser = null;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _annualPlanProvider = context.read<AnnualPlanProvider>();
    _accountProvider = context.read<AccountProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    currentUser = await _accountProvider.getCurrentUser();
    var data = await _annualPlanProvider.get(filter:{'mentorId':this.currentUser.nameid});
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Annual plans"),
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
                'mentorId':this.currentUser.nameid
              };

              var data = await _annualPlanProvider.get(filter: filter);

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
                    builder: (context) => AnnualPlanDetailsScreen(
                      annualPlanModel: null,
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
    if (result?.result == null || result!.result.isEmpty) {
      return Center(
        child: Text("No data available."),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: result!.result.length,
        itemBuilder: (context, index) {
          AnnualPlanModel annualPlan = result!.result[index];
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text('Annual plan for  ${annualPlan.year} year'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnnualPlanDetailsScreen(
                      annualPlanModel: annualPlan,
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
