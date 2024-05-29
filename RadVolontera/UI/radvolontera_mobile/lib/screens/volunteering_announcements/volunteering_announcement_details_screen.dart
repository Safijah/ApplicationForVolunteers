import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/city/city.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import 'package:radvolontera_mobile/models/volunteering_announcement/volunteering_announcement.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/city_provider.dart';
import 'package:radvolontera_mobile/providers/volunteering_announcement_provider.dart';
import 'package:radvolontera_mobile/screens/reports/report_details_screen.dart';
import 'package:radvolontera_mobile/screens/volunteering_announcements/volunteering_announcement_list_screen.dart';
import '../../widgets/master_screen.dart';

class VolunteeringAnnouncementDetailsScreen extends StatefulWidget {
  VolunteeringAnnouncementModel? volunteeringAnnouncementModel;
  VolunteeringAnnouncementDetailsScreen(
      {Key? key, this.volunteeringAnnouncementModel})
      : super(key: key);

  @override
  State<VolunteeringAnnouncementDetailsScreen> createState() =>
      _VolunteeringAnnouncementDetailsScreenState();
}

class _VolunteeringAnnouncementDetailsScreenState
    extends State<VolunteeringAnnouncementDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late VolunteeringAnnouncementProvider _volunteeringAnnouncementProvider;
  late CityProvider _cityProvider;
  bool isLoading = true;
  SearchResult<CityModel>? cityResults;
  dynamic currentUser = null;
  late AccountProvider _accountProvider;

  @override
  void initState() {
    super.initState();
    _volunteeringAnnouncementProvider =
        context.read<VolunteeringAnnouncementProvider>();
    _cityProvider = context.read<CityProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  Future<void> initForm() async {
    currentUser = await _accountProvider.getCurrentUser();
    cityResults = await _cityProvider.get();
    setState(() {
      _initialValue = {
        'notes': widget.volunteeringAnnouncementModel?.notes,
        'place': widget.volunteeringAnnouncementModel?.place,
        'cityId': widget.volunteeringAnnouncementModel?.cityId?.toString(),
        'mentor': currentUser?.nameid ?? '',
        'timeFrom': widget.volunteeringAnnouncementModel?.timeFrom?.toString(),
        'timeTo': widget.volunteeringAnnouncementModel?.timeTo?.toString(),
        'date': widget.volunteeringAnnouncementModel?.date,
      };
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Volunteering Announcement Details",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading) CircularProgressIndicator() else _buildForm(),
            SizedBox(height: 20),
            if (widget.volunteeringAnnouncementModel?.announcementStatus?.name == 'Rejected' &&
                widget.volunteeringAnnouncementModel?.reason != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Reason for rejection: ${widget.volunteeringAnnouncementModel?.reason}",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Notes"),
            name: "notes",
            validator: FormBuilderValidators.required(
              errorText: 'Notes are required',
            ),
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Place"),
            name: "place",
            validator: FormBuilderValidators.required(
              errorText: 'Place is required',
            ),
          ),
          SizedBox(height: 10),
          FormBuilderDropdown<String>(
            name: 'cityId',
            decoration: InputDecoration(
              labelText: 'City',
              suffix: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _formKey.currentState?.fields['cityId']?.reset();
                },
              ),
              hintText: 'Select city',
            ),
            items: cityResults?.result
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
              errorText: 'City is required',
            ),
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(
              labelText: "Time from",
              hintText: "HH:mm",
            ),
            name: "timeFrom",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Time from is required';
              } else if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$')
                  .hasMatch(value)) {
                return 'Enter a valid time in HH:mm format';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
              LengthLimitingTextInputFormatter(5),
            ],
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(
              labelText: "Time to",
              hintText: "HH:mm",
            ),
            name: "timeTo",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Time to is required';
              } else if (!RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$')
                  .hasMatch(value)) {
                return 'Enter a valid time in HH:mm format';
              }
              return null;
            },
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
              LengthLimitingTextInputFormatter(5),
            ],
          ),
          SizedBox(height: 10),
          FormBuilderDateTimePicker(
            name: 'date',
            decoration: InputDecoration(
              labelText: 'Event date',
            ),
            initialEntryMode: DatePickerEntryMode.calendar,
            inputType: InputType.date,
            format: DateFormat('dd-MM-yyyy'),
            initialDate: widget.volunteeringAnnouncementModel?.date ??
                DateTime.now().add(Duration(
                    days: 4)), // Set initialDate to be on or after firstDate
            firstDate: DateTime.now().add(Duration(days: 4)),
            lastDate: DateTime.now().add(Duration(days: 30)),
            validator: FormBuilderValidators.required(
              errorText: 'Date is required',
            ),
            selectableDayPredicate: (date) {
              if (date == null) return false;
              final now = DateTime.now();
              return date.isAfter(now.add(Duration(days: 3))) &&
                  date.isBefore(now.add(Duration(days: 31)));
            },
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    List<Widget> buttons = [];

    if (widget.volunteeringAnnouncementModel == null) {
      buttons.add(_buildSaveButton());
    } else {
      switch (widget.volunteeringAnnouncementModel!.announcementStatus?.name) {
        case 'On hold':
          buttons.add(_buildSaveButton());
          buttons.add(_buildDeleteButton());
          break;
        case 'Approved':
          final announcementDate = widget.volunteeringAnnouncementModel!.date!;
          final now = DateTime.now();
          if (this.widget.volunteeringAnnouncementModel!.hasReport) {
            buttons.add(_buildInfoText("You already sent a report."));
          } else if (now.isAfter(announcementDate.add(Duration(days: 7)))) {
            buttons.add(_buildInfoText("The time for submitting the report has expired"));
          } else if (announcementDate.isBefore(now.subtract(Duration(days: 1)))) {
            buttons.add(_buildSendReportButton());
          } else {
            buttons.add(_buildInfoText("You can send a report after ${DateFormat('dd.MM.yyyy').format(announcementDate)}"));
          }
          break;
        case 'Rejected':
          if (widget.volunteeringAnnouncementModel?.reason != null) {
            buttons.add(_buildCorrectAnnouncementButton());
          }
          break;
        default:
          buttons.add(_buildSaveButton());
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            try {
              _formKey.currentState?.saveAndValidate();
              var formValue = _formKey.currentState?.value;
              var request = {
                'notes': formValue!['notes'],
                'place': formValue['place'],
                'cityId': int.tryParse(formValue['cityId']),
                'mentorId': currentUser.nameid,
                'timeFrom': formValue['timeFrom'],
                'timeTo': formValue['timeTo'],
                'date': (formValue['date'] as DateTime).toIso8601String(),
              };
              if (widget.volunteeringAnnouncementModel == null) {
                await _volunteeringAnnouncementProvider.insert(request);
              } else {
                await _volunteeringAnnouncementProvider.update(
                    widget.volunteeringAnnouncementModel!.id!, request);
              }

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const VolunteeringAnnouncementListScreen()));
            } on Exception catch (e) {
              _showErrorDialog(e.toString());
            }
          }
        },
        child: Text("Save"),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          // Show delete confirmation dialog here
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Delete"),
                content:
                    Text("Are you sure you want to delete this announcement?"),
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
                        if (widget.volunteeringAnnouncementModel != null) {
                          await _volunteeringAnnouncementProvider.delete(
                              widget.volunteeringAnnouncementModel!.id!);
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.of(context).pop();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VolunteeringAnnouncementListScreen(),
                            ),
                          );
                        }
                      } on Exception catch (e) {
                        _showErrorDialog(e.toString());
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
        child: Text("Delete"),
      ),
    );
  }

  Widget _buildSendReportButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReportDetailsScreen(
                reportModel: null,
                announcementId: widget.volunteeringAnnouncementModel!.id,
              ),
            ),
          );
        },
        child: Text("Send Report"),
      ),
    );
  }

  Widget _buildInfoText(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width - 100, // Adjust padding
        child: Text(
          message,
          softWrap: true,
        ),
      ),
    );
  }

  Widget _buildCorrectAnnouncementButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            try {
              _formKey.currentState?.saveAndValidate();
              var formValue = _formKey.currentState?.value;
              var request = {
                'notes': formValue!['notes'],
                'place': formValue['place'],
                'cityId': int.tryParse(formValue['cityId']),
                'mentorId': currentUser.nameid,
                'timeFrom': formValue['timeFrom'],
                'timeTo': formValue['timeTo'],
                'date': (formValue['date'] as DateTime).toIso8601String(),
              };
              await _volunteeringAnnouncementProvider.update(
                  widget.volunteeringAnnouncementModel!.id!, request);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const VolunteeringAnnouncementListScreen()));
            } on Exception catch (e) {
              _showErrorDialog(e.toString());
            }
          }
        },
        child: Text("Correct Announcement"),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
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
