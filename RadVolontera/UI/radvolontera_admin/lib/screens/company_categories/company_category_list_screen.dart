

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/company_category/company_category.dart';
import 'package:radvolontera_admin/providers/company_category_provider.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';
import 'company_category_details_screen.dart';

class CompanyCategoryListScreen extends StatefulWidget {
  const CompanyCategoryListScreen({super.key});

  @override
  State<CompanyCategoryListScreen> createState() => _CompanyCategoryListScreenState();
}

class _CompanyCategoryListScreenState extends State<CompanyCategoryListScreen> {
  late CompanyCategoryProvider _companyCategoryProvider;
  SearchResult<CompanyCategoryModel> ? result;
    TextEditingController _headingController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

 @override
  void initState() {
    super.initState();
     _companyCategoryProvider = context.read<CompanyCategoryProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
     var data = await _companyCategoryProvider.get();
      setState(() {
                  result = data;
                });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Company category list"),
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
            child: TextField(
              decoration: InputDecoration(labelText: "Name"),
              controller: _headingController,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                var data = await _companyCategoryProvider.get(filter: {
                  'name': _headingController.text,
                });

                setState(() {
                  result = data;
                });
              },
              child: Text("Search")),
              SizedBox(
            width: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CompanyCategoryDetailsScreen(
                      companyCategory: null,
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
                'ID',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
          ],
          rows: result?.result
              .map((CompanyCategoryModel e) => DataRow(
                    onSelectChanged: (selected) => {
                      if (selected == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CompanyCategoryDetailsScreen(companyCategory: e,),
                          ),
                        )
                      }
                    },
                    cells: [
                      DataCell(Text(e.id?.toString() ?? "")),
                      DataCell(Text(e.name ?? "")),
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


