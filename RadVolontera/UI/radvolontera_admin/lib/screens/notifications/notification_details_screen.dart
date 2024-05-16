import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/notification/notification.dart';
import 'package:radvolontera_admin/models/section/section.dart';
import 'package:radvolontera_admin/providers/account_provider.dart';
import 'package:radvolontera_admin/providers/notification_provider.dart';
import 'package:radvolontera_admin/providers/section_provider.dart';
import 'package:radvolontera_admin/screens/notifications/notification_list_screen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';

class NotificationDetailScreen extends StatefulWidget {
  NotificationModel? notification;
  NotificationDetailScreen({Key? key, this.notification}) : super(key: key);

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late NotificationProvider _notificationProvider;
  late SectionProvider _sectionProvider;
  late AccountProvider _accountProvider;
  SearchResult<SectionModel>? sectionsResult;
  bool isLoading = true;
  dynamic currentUser = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'heading': widget.notification?.heading,
      'content': widget.notification?.content,
      'sectionId': widget.notification?.sectionId?.toString(),
      'adminId': widget.notification?.adminId.toString()
    };

    _notificationProvider = context.read<NotificationProvider>();
    _sectionProvider = context.read<SectionProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
    sectionsResult = await _sectionProvider.get();
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
                      _formKey.currentState?.patchValue(
                          {'adminId': this.currentUser.nameid});
                      _formKey.currentState?.saveAndValidate();

                      if (widget.notification == null) {
                        await _notificationProvider
                            .insert(_formKey.currentState?.value);
                      } else {
                        await _notificationProvider.update(
                            widget.notification!.id!,
                            _formKey.currentState?.value);
                      }

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const NotificationListScreen()));
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
                },
                child: Text("Save"),
              ),
            ),
             if (widget.notification != null)
             ...[
            ElevatedButton(
              onPressed: () {
                // Show delete confirmation dialog here
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Delete"),
                      content: Text("Are you sure you want to delete this notification?"),
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
                              if (widget.notification != null) {
                                await _notificationProvider.delete(widget.notification!.id!);
                               Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pop();
                   await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationListScreen(),
                      ),
                    );
                  }
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
                primary: Colors.red,// Set button color to red
              ),
              child: Text("Delete"),
            ),
             ],
          ],
        ),
      ],
    ),
    title: this.widget.notification?.heading ?? "Notification details",
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
                            initialValue: this.currentUser != null ? this.currentUser?.nameid : '',
                            style: TextStyle(color: Colors.transparent),
                            decoration: InputDecoration.collapsed(hintText: ''),
                            onChanged: (val) {
                              field.didChange(this.currentUser.nameid);
                            },
                          ),
                        );
                      },
                    ),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Heading"),
                      name: "heading",
                      validator: FormBuilderValidators.required(
                        errorText: 'Heading is required',
                      ),
                    ),
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Content"),
                      name: "content",
                      validator: FormBuilderValidators.required(
                        errorText: 'Content is required',
                      ),
                    ),
                    SizedBox(height: 10),
                    FormBuilderDropdown<String>(
                      name: 'sectionId',
                      decoration: InputDecoration(
                        labelText: 'Notification section',
                        suffix: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['sectionId']?.reset();
                          },
                        ),
                        hintText: 'Select notification section',
                      ),
                      items: sectionsResult?.result
                          .map(
                            (item) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: item.id.toString(),
                              child: Text(item.name ?? ""),
                            ),
                          )
                          .toList() ??
                          [],
                      validator: FormBuilderValidators.required(
                        errorText: 'Notification section is required',
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
