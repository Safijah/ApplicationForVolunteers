import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/useful_link/useful_link.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/providers/useful_link_provider.dart';
import 'package:radvolontera_admin/screens/useful_links/useful_link_list_screen.dart';

import '../../widgets/master_screen.dart';

class UsefulLinkDetailsScreen extends StatefulWidget {
  UsefulLinkModel? usefulLink;
  UsefulLinkDetailsScreen({Key? key, this.usefulLink}) : super(key: key);

  @override
  State<UsefulLinkDetailsScreen> createState() =>
      _UsefulLinkDetailsScreenState();
}

class _UsefulLinkDetailsScreenState extends State<UsefulLinkDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late UsefulLinkProvider _usefulLinkProvider;
  late AccountProvider _accountProvider;
  bool isLoading = true;
  dynamic currentUser = null;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'name': widget.usefulLink?.name,
      'urlLink': widget.usefulLink?.urlLink,
      'adminId': widget.usefulLink?.adminId.toString()
    };

    _usefulLinkProvider = context.read<UsefulLinkProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  Future<void> initForm() async {
    currentUser = await _accountProvider.getCurrentUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
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
                        _formKey.currentState?.patchValue(
                            {'adminId': this.currentUser.nameid});
                        _formKey.currentState?.saveAndValidate();

                        if (widget.usefulLink == null) {
                          await _usefulLinkProvider
                              .insert(_formKey.currentState?.value);
                        } else {
                          await _usefulLinkProvider.update(
                              widget.usefulLink!.id!,
                              _formKey.currentState?.value);
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const UsefulLinkListScreen(),
                        ));
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
                  child: Text("Save"),
                ),
              ),
              if(widget.usefulLink!= null)
              ...[
              ElevatedButton(
                onPressed: () {
                  // Show delete confirmation dialog here
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Delete"),
                        content: Text(
                            "Are you sure you want to delete this useful link?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Add delete logic here
                              try {
                                if (widget.usefulLink != null) {
                                  await _usefulLinkProvider
                                      .delete(widget.usefulLink!.id!);
                                  Navigator.of(context).pop(); // Close the dialog
                                  Navigator.of(context).pop();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UsefulLinkListScreen(),
                                    ),
                                  );
                                }
                              } on Exception catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,//change background color of button
                backgroundColor: Colors.red, // Set button color to red
                ),
                child: Text("Delete"),
              ),
              ]
            ],
          ),
        ],
      ),
      title: this.widget.usefulLink?.name ?? "Useful link details",
      showBackButton: true,
    );
  }

  Padding _buildForm() {
    return Padding(
      padding: EdgeInsets.only(top: 50.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
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
                      FormBuilderField(
                        name: 'adminId',
                        builder: (FormFieldState<dynamic> field) {
                          return SizedBox(
                            height: 0,
                            width: 0,
                            child: TextFormField(
                              initialValue: this.currentUser != null
                                  ? this.currentUser?.nameid
                                  : '',
                              style: TextStyle(color: Colors.transparent),
                              decoration:
                                  InputDecoration.collapsed(hintText: ''),
                              onChanged: (val) {
                                field.didChange(this.currentUser.nameid);
                              },
                            ),
                          );
                        },
                      ),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Name"),
                        name: "name",
                        validator: FormBuilderValidators.required(
                          errorText: 'Name is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Url"),
                        name: "urlLink",
                        validator: FormBuilderValidators.required(
                          errorText: 'Url link is required',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
