import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/screens/users/user_list_screen.dart';
import 'package:intl/intl.dart';
import '../../models/search_result.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  AccountModel? user;
  UserDetailsScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class DropdownItem {
  final int? value;
  final String displayText;

  DropdownItem(this.value, this.displayText);
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AccountProvider _accountProvider;
  bool isLoading = true;
  dynamic currentUser = null;

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
    // TODO: implement initState
    if (widget.user != null) {
      isEditMode = true;
    }
    super.initState();
    _initialValue = {
      'firstName': widget.user?.firstName,
      'lastName': widget.user?.lastName,
      'phoneNumber': widget.user?.phoneNumber,
      'gender': widget.user?.gender.toString(),
      'userType': widget.user?.userType.toString(),
      'email': widget.user?.email,
      'password': widget.user?.password,
      'confirmPassword': widget.user?.confirmPassword,
      'birthDate': widget.user?.birthDate
    };

    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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
      // ignore: sort_child_properties_last
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
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
                            'userType': int.tryParse(formValue['userType']),
                            'email': formValue['email'],
                            'password': formValue['password'] ?? '',
                            'confirmPassword':
                                formValue['confirmPassword'] ?? '',
                            'birthDate':
                                formValue['birthDate'].toIso8601String(),
                            'userName': formValue['email']
                          };
                          if (widget.user == null) {
                            await _accountProvider.insert(request);
                          } else {
                            await _accountProvider.update(
                                widget.user!.id!, request);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const UserListScreen()));
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("OK"))
                                    ],
                                  ));
                        }
                      }
                    },
                    child: Text("Save")),
              )
            ],
          )
        ],
      ),
      title: this.widget.user?.fullName ?? "User details",
    );
  }

  Padding _buildForm() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0), // Adjust the top margin as needed
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Image.asset(
                        "assets/images/form.png",
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: "First name"),
                                name: "firstName",
                                validator: FormBuilderValidators.required(
                                  errorText: 'First name is required',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: "Last name"),
                                name: "lastName",
                                validator: FormBuilderValidators.required(
                                  errorText: 'Last name is required',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                decoration: InputDecoration(labelText: "Email"),
                                name: "email",
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: 'Email is required',
                                  ),
                                  FormBuilderValidators.email(
                                    errorText:
                                        'Please insert valid email format',
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: "Phone number"),
                                name: "phoneNumber",
                                validator: FormBuilderValidators.required(
                                  errorText: 'Phone number is required',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'userType',
                                decoration: InputDecoration(
                                  labelText: 'User type',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['userType']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select user role section',
                                ),
                                items: roles
                                        .map(
                                          (item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: item.value.toString(),
                                            child: Text(item.displayText ?? ""),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                                validator: FormBuilderValidators.required(
                                  errorText: 'Role is required',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'gender',
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['gender']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select gender',
                                ),
                                items: genders
                                        .map(
                                          (item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: item.value.toString(),
                                            child: Text(item.displayText ?? ""),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                                validator: FormBuilderValidators.required(
                                  errorText: 'Gender is required',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: "Password"),
                                name: "password",
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
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderTextField(
                                decoration: InputDecoration(
                                    labelText: "Confirm password"),
                                name: "confirmPassword",
                                obscureText: true,
                                validator: (value) {
                                  if((_formKey.currentState!.fields['password']?.value != null &&  _formKey.currentState!.fields['password']?.value.isNotEmpty)  || !isEditMode){
                                   if (value == null || value.isEmpty) {
                                    return 'Confirm password is required';
                                  }
                                  if (value !=
                                      _formKey.currentState!.fields['password']
                                          ?.value) {
                                    return 'Passwords do not match';
                                  }
                                  return null; // Return null to indicate the input is valid
                                }},
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDateTimePicker(
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
                            )
                          ],
                        )
                      ],
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
}
