import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/notification/notification.dart';
import 'package:radvolontera_admin/models/search_result.dart';
import 'package:radvolontera_admin/providers/notification_provider.dart';
import 'package:radvolontera_admin/screens/notifications/notification_details_screen.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
  void functionThatSetsTheState(){
}


}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late NotificationProvider _notificationProvider;
  SearchResult<NotificationModel> ? result;
    TextEditingController _headingController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

 @override
  void initState() {
    super.initState();
     _notificationProvider = context.read<NotificationProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
     var data = await _notificationProvider.get();
      setState(() {
                  result = data;
                });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Notification list"),
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
              decoration: InputDecoration(labelText: "Heading"),
              controller: _headingController,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                var data = await _notificationProvider.get(filter: {
                  'heading': _headingController.text,
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
                    builder: (context) => NotificationDetailScreen(
                      notification: null,
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
                'Heading',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Section',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Content',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
          ],
          rows: result?.result
              .map((NotificationModel e) => DataRow(
                    onSelectChanged: (selected) => {
                      if (selected == true) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationDetailScreen(notification: e,),
                          ),
                        )
                      }
                    },
                    cells: [
                      DataCell(Text(e.heading ?? "")),
                      DataCell(Text(e.section?.name.toString() ?? "")),
                      DataCell(Text(e.content ?? "")),
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


