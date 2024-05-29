import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/monitoring/monitoring.dart';
import 'package:radvolontera_admin/providers/monitoring_provider.dart';
import 'package:radvolontera_admin/screens/monitoring/monitoring_list_screen.dart';
import '../../models/search_result.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class MonitoringDetailsScreen extends StatefulWidget {
  MonitoringModel? monitoring;
  MonitoringDetailsScreen({Key? key, this.monitoring}) : super(key: key);

  @override
  State<MonitoringDetailsScreen> createState() =>
      _MonitoringDetailsScreenState();
}

class _MonitoringDetailsScreenState extends State<MonitoringDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late MonitoringProvider _monitoringProvider;
  late AccountProvider _accountProvider;
  SearchResult<AccountModel>? mentorsResult;
  bool isLoading = true;
  dynamic currentUser = null;
  @override
  void initState() {
    super.initState();
    _initialValue = {
      'notes': widget.monitoring?.notes,
      'url': widget.monitoring?.url.toString(),
      'date': widget.monitoring?.date,
      'mentorId': widget.monitoring?.mentorId.toString()
    };

    _monitoringProvider = context.read<MonitoringProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    mentorsResult = await _accountProvider.get(filter: {
      'userTypes': 2,
    });
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
                        _formKey.currentState?.saveAndValidate();
                        var formValue = _formKey.currentState?.value;
                        var request = {
                          'notes': formValue!['notes'],
                          'url': formValue['url'],
                          'mentorId': formValue['mentorId'],
                          'date': (formValue['date'] as DateTime).toIso8601String(),
                        };
                        if (widget.monitoring == null) {
                          await _monitoringProvider.insert(request);
                        } else {
                          await _monitoringProvider.update(
                              widget.monitoring!.id!, request);
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const MonitoringListScreen()));
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    }
                  },
                  child: Text("Save"),
                ),
              ),
              if (widget.monitoring != null) ...[
                ElevatedButton(
                  onPressed: () {
                    // Show delete confirmation dialog here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Delete"),
                          content: Text(
                              "Are you sure you want to delete this monitoring?"),
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
                                  if (widget.monitoring != null) {
                                    await _monitoringProvider
                                        .delete(widget.monitoring!.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    Navigator.of(context).pop();
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MonitoringListScreen(),
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
                    foregroundColor:
                        Colors.white, //change background color of button
                    backgroundColor: Colors.red,
                  ),
                  child: Text("Delete"),
                ),
              ]
            ],
          ),
        ],
      ),
      title: "Monitoring details",
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
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Notes"),
                        name: "notes",
                        validator: FormBuilderValidators.required(
                          errorText: 'Notes is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Url"),
                        name: "url",
                        validator: FormBuilderValidators.required(
                          errorText: 'Url is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDropdown<String>(
                        name: 'mentorId',
                        decoration: InputDecoration(
                          labelText: 'Mentor',
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['mentorId']
                                  ?.reset();
                            },
                          ),
                          hintText: 'Select student',
                        ),
                        items: mentorsResult?.result
                                ?.map(
                                  (item) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: item.id.toString(),
                                    child: Text(
                                        '${item.firstName} ${item.lastName}'),
                                  ),
                                )
                                .toList() ??
                            [],
                        validator: FormBuilderValidators.required(
                          errorText: 'Student is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDateTimePicker(
                                name: 'date',
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                ),
                                initialEntryMode: DatePickerEntryMode.calendar,
                                inputType: InputType.date,
                                format: DateFormat('dd-MM-yyyy'),
                                validator: FormBuilderValidators.required(
                                  errorText: 'Date is required',
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
