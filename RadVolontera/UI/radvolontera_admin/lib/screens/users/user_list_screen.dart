import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/screens/users/user_details_screen.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';
import '../notifications/notification_details_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _UserListScreenState extends State<UserListScreen> {
  late AccountProvider _accountProvider;
  SearchResult<AccountModel>? result;
  TextEditingController _nameController = new TextEditingController();
  String? selectedValue; // variable to store the selected value

  List<DropdownItem> dropdownItems = [
     DropdownItem(0, 'All'),
    DropdownItem(1, 'Admins'),
    DropdownItem(2, 'Mentors'),
    DropdownItem(3, 'Students'),
  ];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    var data = await _accountProvider.get();
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("User list"),
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
              decoration: InputDecoration(labelText: "First or last name"),
              controller: _nameController,
            ),
          ),
          Expanded(
              child: // list of dropdown items
                  DropdownButton<String>(
            value: selectedValue,
            hint: Text('Select user type'), // optional hint text
            onChanged: (newValue) async {
              setState(() {
                selectedValue = newValue; // update the selected value
              });

                   var data = await _accountProvider.get(filter: {
                  'name': _nameController.text,
                  'userTypes': selectedValue 
                });

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
                var data = await _accountProvider.get(filter: {
                  'name': _nameController.text,
                  'userTypes': selectedValue 
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
                    builder: (context) => UserDetailsScreen(
                      user: null,
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
          columns: [
            DataColumn(
              label: Text(
                'First name',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Last name',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'Phone number',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
            DataColumn(
              label: Text(
                'User type',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ),
          ],
          rows: result?.result
                  .map((AccountModel e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UserDetailsScreen(user: e),
                                      ),
                                    ),
                                  }
                              },
                          cells: [
                            DataCell(Text(e.firstName ?? "")),
                            DataCell(Text(e.lastName ?? "")),
                            DataCell(Text(e.email ?? "")),
                            DataCell(Text(e.phoneNumber ?? "")),
                            DataCell(Text(e.role ?? "")),
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