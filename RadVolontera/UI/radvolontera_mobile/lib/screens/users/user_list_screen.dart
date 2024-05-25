import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/screens/users/user_details_screen.dart';
import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late AccountProvider _accountProvider;
  SearchResult<AccountModel>? result;
  TextEditingController _nameController = new TextEditingController();
  String? selectedValue; // variable to store the selected value
  dynamic currentUser = null;

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
    // Call your method here
    _loadData();
  }

  _loadData() async {
    currentUser = await _accountProvider.getCurrentUser();
    var data = await _accountProvider.getStudentsForMentor(currentUser.nameid);
    setState(() {
      result = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("User list"),
      child: Container(
        child: Column(
          children: [Expanded(child: _buildDataListView())],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    return result == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: result!.result.length,
            itemBuilder: (context, index) {
              final user = result!.result[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email}'),
                      Text('Phone: ${user.phoneNumber}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(user: user),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
