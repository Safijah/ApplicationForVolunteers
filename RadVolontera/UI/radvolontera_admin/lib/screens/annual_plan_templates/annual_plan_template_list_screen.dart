import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/annual_plan_template/annual_plan_template.dart';
import 'package:radvolontera_admin/models/search_result.dart';
import 'package:radvolontera_admin/providers/annual_plan_template_provider.dart';
import 'package:radvolontera_admin/screens/annual_plan_templates/annual_plan_template_details.dart';
import 'package:radvolontera_admin/screens/volunteering_announcements/volunteering_announcement_details_screen.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class AnnualPlanTemplateListscreen extends StatefulWidget {
  const AnnualPlanTemplateListscreen({super.key});

  @override
  State<AnnualPlanTemplateListscreen> createState() =>
      _AnnualPlanTemplateListscreenState();
}

List<DropdownItem> dropdownItems = [
  DropdownItem(2024, '2024'),
  DropdownItem(2023, '2025'),
  DropdownItem(2022, '2026'),
  DropdownItem(2021, '2027'),
  DropdownItem(2020, '2028'),
  DropdownItem(2019, '2029'),
];

class _AnnualPlanTemplateListscreenState
    extends State<AnnualPlanTemplateListscreen> {
  late AnnualPlanTemplateProvider _annualPlanTemplateProvider;
  SearchResult<AnnualPlanTemplateModel>? result;
  String? selectedMentorValue; // variable to store the selected value
  String? selectedValue;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _annualPlanTemplateProvider = context.read<AnnualPlanTemplateProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _annualPlanTemplateProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Annual plan templates"),
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
              };

              var data = await _annualPlanTemplateProvider.get(filter: filter);

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
                    builder: (context) => AnnualPlanTemplateDetailsScreen(
                      annualPlanTemplateModel: null,
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
          AnnualPlanTemplateModel annualPlan = result!.result[index];
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text('Template for  ${annualPlan.year} year'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnnualPlanTemplateDetailsScreen(
                      annualPlanTemplateModel: annualPlan,
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
