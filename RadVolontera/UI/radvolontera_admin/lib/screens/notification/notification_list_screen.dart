import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/notification/notification.dart';
import 'package:radvolontera_admin/models/search_result.dart';
import 'package:radvolontera_admin/providers/notification_provider.dart';
import 'package:radvolontera_admin/screens/notification/notification_details_screen.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late NotificationProvider _notificationProvider;
  SearchResult<NotificationModel> ? result;
    TextEditingController _headingController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _notificationProvider = context.read<NotificationProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Product list"),
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
              child: Text("Search"))
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: DataTable(
          
          columns: [
            const DataColumn(
              label: Expanded(
                child: Text(
                  'ID',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Heading',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const DataColumn(
              label: Expanded(
                child: Text(
                  'Section',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          rows: result?.result
                  .map((NotificationModel e) => DataRow(onSelectChanged: (selected) => {
                    if(selected == true) {
                        
                       Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NotificationDetailsWidget(notificationModel: e,),
                          ),
                        )
                    }
                  },cells: [
                        DataCell(Text(e.id?.toString() ?? "")),
                        DataCell(Text(e.heading ?? "")),
                        DataCell(Text(e.section?.name.toString() ?? "")),
                      ]))
                  .toList() ??
              []),
    ));
  }
}


