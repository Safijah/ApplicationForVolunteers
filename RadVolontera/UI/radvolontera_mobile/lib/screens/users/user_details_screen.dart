import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  AccountModel? user;
  UserDetailsScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AccountProvider _accountProvider;
  bool isLoading = true;
  dynamic currentUser = null;
  bool isEditMode = false;

  @override
  void initState() {
    if (widget.user != null) {
      isEditMode = true;
    }
    super.initState();
    _initialValue = {
      'firstName': widget.user?.firstName,
      'lastName': widget.user?.lastName,
      'phoneNumber': widget.user?.phoneNumber,
      'gender': widget.user?.gender.toString(),
      'email': widget.user?.email,
      'birthDate': widget.user?.birthDate != null
      ? DateFormat('dd.MM.yyyy').format(widget.user!.birthDate!)
      : '',
    };

    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  Future initForm() async {
    currentUser = await _accountProvider.getCurrentUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: this.widget.user?.fullName ?? "User details",
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
        ],
      ),
    );
  }

  Padding _buildForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 48), // Space to balance the back button
                    ],
                  ),
                  SizedBox(height: 20),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "First name"),
                    name: "firstName",
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Last name"),
                    name: "lastName",
                    readOnly: true,
                    validator: FormBuilderValidators.required(
                      errorText: 'Last name is required',
                    ),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Email"),
                    name: "email",
                    readOnly: true,
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Phone number"),
                    name: "phoneNumber",
                    readOnly: true,
                    
                  ),
                  SizedBox(height: 10),
                 FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Date of birth"),
                    name: "birthDate",
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
