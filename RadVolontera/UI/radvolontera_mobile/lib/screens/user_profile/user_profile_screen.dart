import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AccountProvider _accountProvider;
  bool isLoading = true;
  dynamic currentUser = null;
late AccountModel userProfile;
  List<DropdownItem> genders = [
    DropdownItem(1, 'Male'),
    DropdownItem(2, 'Female')
  ];
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  Future initForm() async {
    // Fetch user info from API
    currentUser = await _accountProvider.getCurrentUser();
   userProfile = await _accountProvider.userProfile(currentUser.nameid);
    setState(() {
      isLoading = false;
      // Set initial values for form fields
      _initialValue = {
        'firstName': userProfile?.firstName,
        'lastName': userProfile?.lastName,
        'phoneNumber': userProfile?.phoneNumber,
        'gender': userProfile?.gender.toString(),
        'email': userProfile?.email,
        'birthDate': userProfile?.birthDate,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? Container() : _buildPersonalInfoForm(),
          isLoading ? Container() : _buildChangePasswordForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        _formKey.currentState?.saveAndValidate();
                        var formValue = _formKey.currentState?.value;
                        var request = {
                          'firstName': formValue!['firstName'],
                          'lastName': formValue['lastName'],
                          'phoneNumber': formValue['phoneNumber'],
                          'gender': int.tryParse(formValue['gender']),
                          'email': formValue['email'],
                          'birthDate':
                              formValue['birthDate'].toIso8601String(),
                        };
                        // Update user info
                        await _accountProvider.update(currentUser!.id!, request);
                      } on Exception catch (e) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Error"),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              )
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: Text("Save Personal Info"),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    // Implement change password logic here
                    // Fetch the current password, new password, and repeat password
                    // Update the password using your account provider
                  },
                  child: Text("Change Password"),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    // Implement logout logic here
                  },
                  child: Text("Logout"),
                ),
              )
            ],
          )
        ],
      ),
      title: "User Profile",
    );
  }

  Padding _buildPersonalInfoForm() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
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
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "First name"),
                    name: "firstName",
                    validator: FormBuilderValidators.required(
                      errorText: 'First name is required',
                    ),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Last name"),
                    name: "lastName",
                    validator: FormBuilderValidators.required(
                      errorText: 'Last name is required',
                    ),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Email"),
                    name: "email",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: 'Email is required',
                      ),
                      FormBuilderValidators.email(
                        errorText: 'Please insert valid email format',
                      ),
                    ]),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Phone number"),
                    name: "phoneNumber",
                    validator: FormBuilderValidators.required(
                      errorText: 'Phone number is required',
                    ),
                  ),
                  SizedBox(height: 10),
                  FormBuilderDropdown<String>(
                    name: 'gender',
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      hintText: 'Select gender',
                    ),
                    items: genders
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.value.toString(),
                            child: Text(item.displayText ?? ""),
                          ),
                        )
                        .toList(),
                    validator: FormBuilderValidators.required(
                      errorText: 'Gender is required',
                    ),
                  ),
                  SizedBox(height: 10),
                  FormBuilderDateTimePicker(
                    name: 'birthDate',
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                    initialEntryMode: DatePickerEntryMode.calendar,
                    inputType: InputType.date,
                    format: DateFormat('dd-MM-yyyy'),
                    validator: FormBuilderValidators.required(
                      errorText: 'Date of Birth is required',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildChangePasswordForm() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
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
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Current Password"),
                    name: "currentPassword",
                    obscureText: true,
                    validator: FormBuilderValidators.required(
                      errorText: 'Current Password is required',
                    ),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "New Password"),
                    name: "newPassword",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New Password is required';
                      }
                      if (value.length < 6) {
                        return 'New Password must be at least 6 characters';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'New Password must contain at least one lowercase letter';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'New Password must contain at least one uppercase letter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Repeat Password"),
                    name: "repeatPassword",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Repeat Password is required';
                      }
                      if (value !=
                          _formKey.currentState!.fields['newPassword']?.value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              _formKey.currentState?.saveAndValidate();
                              var formValue = _formKey.currentState?.value;
                              var currentPassword = formValue!['currentPassword'];
                              var newPassword = formValue['newPassword'];
                              // Implement logic to change password
                              // await _accountProvider.changePassword(
                              //     currentUser!.id!,
                              //     currentPassword,
                              //     newPassword);
                            } on Exception catch (e) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    )
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        child: Text("Change Password"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}
