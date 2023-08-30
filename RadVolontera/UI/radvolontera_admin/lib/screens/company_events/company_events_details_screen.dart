

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/compnay_event/company_event.dart';
import 'package:radvolontera_admin/providers/company_event_provider.dart';
import 'package:radvolontera_admin/providers/company_provider.dart';
import 'package:radvolontera_admin/screens/company_events/company_events_list_screen.dart';

import '../../models/company/company.dart';
import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';

class CompanyEventDetailsScreen extends StatefulWidget {
  CompanyEventModel? companyEvent;
  CompanyEventDetailsScreen({Key? key,  this.companyEvent}) : super(key: key);

  @override
  State<CompanyEventDetailsScreen> createState() =>
      _CompanyEventDetailsScreenState();
}

class _CompanyEventDetailsScreenState extends State<CompanyEventDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CompanyEventProvider _companyEventProvider;
  late CompanyProvider _companyProvider;
  SearchResult<CompanyModel>? companyResult;
  bool isLoading = true;
  dynamic currentUser = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'eventName': widget.companyEvent?.eventName,
      'location': widget.companyEvent?.location,
      'time': widget.companyEvent?.time?.toString(),
      'companyId': widget.companyEvent?.companyId.toString(),
      'eventDate': widget.companyEvent?.eventDate
    };

    _companyEventProvider = context.read<CompanyEventProvider>();
    _companyProvider = context.read<CompanyProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
    companyResult = await _companyProvider.get();
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
                            'eventName': formValue!['eventName'],
                            'location': formValue['location'],
                            'time': formValue['time'],
                            'companyId': int.tryParse(formValue['companyId']),
                            'eventDate': formValue['eventDate'].toIso8601String()
                          };
                          if (widget.companyEvent == null) {
                            await _companyEventProvider
                                .insert(request);
                          } else {
                            await _companyEventProvider.update(widget.companyEvent!.id!,
                               request);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CompanyEventListScreen()));
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
      title: "Company event details",
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
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Event name"),
                        name: "eventName",
                        validator: FormBuilderValidators.required(
                          errorText: 'Event name is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Location"),
                        name: "location",
                        validator: FormBuilderValidators.required(
                          errorText: 'Location required',
                        ),
                      ),
                      SizedBox(height: 10),
                     FormBuilderDropdown<String>(
                                name: 'companyId',
                                decoration: InputDecoration(
                                  labelText: 'Company',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['companyId']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select student',
                                ),
                                items: companyResult
                                        ?.result.map(
                                          (item) => DropdownMenuItem(
                                            alignment:
                                                AlignmentDirectional.center,
                                            value: item.id.toString(),
                                            child: Text(item.name ?? ""),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                                validator: FormBuilderValidators.required(
                                  errorText: 'Company is required',
                                ),
                              ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Time",
                          hintText: "12", // Optional placeholder text
                        ),
                        name: "time",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Time is required'),
                          FormBuilderValidators.numeric(
                              errorText: 'Enter a valid time in format 00'),
                          (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length != 2) {
                              return 'Enter a valid time';
                            }
                            return null; // Return null to indicate valid input
                          },
                        ]),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(
                              4), // Limit input to 4 characters
                        ],
                      ),
                       SizedBox(height: 10),
                       FormBuilderDateTimePicker(
                                name: 'eventDate',
                                decoration: InputDecoration(
                                  labelText: 'Event date',
                                ),
                                initialEntryMode: DatePickerEntryMode.calendar,
                                inputType: InputType.date,
                                format: DateFormat('dd-MM-yyyy'),
                                validator: FormBuilderValidators.required(
                                  errorText: 'Event date is required',
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
