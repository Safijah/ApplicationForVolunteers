import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/screens/home/home_screen.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _passFormKey = GlobalKey<FormBuilderState>();
  late AccountProvider _accountProvider;
  bool isLoading = true;
  dynamic currentUser = null;
  late AccountModel userProfile;

  List<DropdownItem> roles = [
    DropdownItem(1, 'Admin'),
    DropdownItem(2, 'Mentor'),
    DropdownItem(3, 'Student'),
  ];
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
    currentUser = await _accountProvider.getCurrentUser();
    userProfile = await _accountProvider.userProfile(currentUser.nameid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildForm(),
                  _buildPasswordForm(),
                ],
              ),
            ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              decoration: InputDecoration(labelText: "First name"),
              name: "firstName",
              initialValue: userProfile.firstName,
              validator: FormBuilderValidators.required(
                errorText: 'First name is required',
              ),
            ),
            SizedBox(height: 10),
            FormBuilderTextField(
              decoration: InputDecoration(labelText: "Last name"),
              name: "lastName",
              initialValue: userProfile.lastName,
              validator: FormBuilderValidators.required(
                errorText: 'Last name is required',
              ),
            ),
            SizedBox(height: 10),
            FormBuilderTextField(
              decoration: InputDecoration(labelText: "Email"),
              name: "email",
              initialValue: userProfile.email,
              readOnly: true,
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
              initialValue: userProfile.phoneNumber,
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
              initialValue: userProfile.gender.toString(),
              items: genders
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.value.toString(),
                      child: Text(item.displayText),
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
              initialValue: userProfile.birthDate,
              validator: FormBuilderValidators.required(
                errorText: 'Date of Birth is required',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _passFormKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              decoration: InputDecoration(labelText: "Current Password"),
              name: "currentPassword",
              obscureText: true,
              validator: FormBuilderValidators.required(
                errorText: 'Field is required',
              ),
            ),
            SizedBox(height: 10),
            FormBuilderTextField(
              decoration: InputDecoration(labelText: "New Password"),
              name: "newPassword",
              obscureText: true,
               validator: (value) {
                                  if (!isEditMode ||
                                      value != null && value.isNotEmpty) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    if (!value.contains(RegExp(r'[a-z]'))) {
                                      return 'Password must contain at least one lowercase letter';
                                    }
                                    if (!value.contains(RegExp(r'[A-Z]'))) {
                                      return 'Password must contain at least one uppercase letter';
                                    }
                                    return null; // Return null to indicate the input is valid
                                  }
                                },
            ),
            SizedBox(height: 10),
            FormBuilderTextField(
              decoration: InputDecoration(labelText: "Repeat Password"),
              name: "repeatPassword",
              obscureText: true,
              validator: FormBuilderValidators.required(
                errorText: 'Field is required',
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _changePassword,
                  child: Text("Change password"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        _formKey.currentState?.saveAndValidate();
        var formValue = _formKey.currentState?.value;
        var request = {
          'firstName': formValue!['firstName'],
          'lastName': formValue['lastName'],
          'phoneNumber': formValue['phoneNumber'],
          'gender': int.tryParse(formValue['gender'] ?? '1'),
          'userType': userProfile.userType,
          'email': formValue['email'],
          'password': formValue['password'] ?? '',
          'confirmPassword': formValue['confirmPassword'] ?? '',
          'birthDate': formValue['birthDate'].toIso8601String(),
          'userName': formValue['email']
        };

        await _accountProvider.updateProfile(userProfile.id!, request);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePageScreen()),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Success"),
            content: Text("Profile updated successfully"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
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
              ),
            ],
          ),
        );
      }
    }
  }

  void _changePassword() async {
    if (_passFormKey.currentState?.validate() ?? false) {
      try {
        _passFormKey.currentState?.save();
        var formValue = _passFormKey.currentState?.value;
        var currentPassword = formValue!['currentPassword'];
        var newPassword = formValue['newPassword'];
        var repeatPassword = formValue['repeatPassword'];

        if (newPassword != repeatPassword) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Error"),
              content: Text("New Passwords do not match"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
          return;
        }

        var request = {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': newPassword
        };
        await _accountProvider.changePassword(
          userProfile.id!,
          request,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePageScreen()),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Success"),
            content: Text("Password changed successfully"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
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
              ),
            ],
          ),
        );
      }
    }
  }
}

