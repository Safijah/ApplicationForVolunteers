


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/useful_link/useful_link.dart';
import 'package:radvolontera_admin/providers/useful_link_provider.dart';
import 'package:radvolontera_admin/screens/useful_links/useful_link_details_screen.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';

class UsefulLinkListScreen extends StatefulWidget {
  const UsefulLinkListScreen({super.key});

  @override
  State<UsefulLinkListScreen> createState() => _UsefulLinkListScreenState();
}

class _UsefulLinkListScreenState extends State<UsefulLinkListScreen> {
  late UsefulLinkProvider _usefulLinkProvider;
  SearchResult<UsefulLinkModel> ? result;
    TextEditingController _headingController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

 @override
  void initState() {
    super.initState();
     _usefulLinkProvider = context.read<UsefulLinkProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
     var data = await _usefulLinkProvider.get();
      setState(() {
                  result = data;
                });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Useful links list"),
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
                var data = await _usefulLinkProvider.get(filter: {
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
                    builder: (context) => UsefulLinkDetailsScreen(
                      usefulLink: null,
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
          columns: [
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Url',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
          ],
          rows: result?.result
              .map((UsefulLinkModel e) => DataRow(
                    onSelectChanged: (selected) => {
                      if (selected == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UsefulLinkDetailsScreen(usefulLink: e,),
                          ),
                        )
                      }
                    },
                    cells: [
                      DataCell(Text(e.name ?? "")),
                      DataCell(Text(e.urlLink ?? "")),
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


