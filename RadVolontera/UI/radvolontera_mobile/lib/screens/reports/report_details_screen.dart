import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import 'package:radvolontera_mobile/models/report/report.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/report_provider.dart';
import 'package:radvolontera_mobile/screens/reports/reports_list_screen.dart';

import '../../widgets/master_screen.dart';

class ReportDetailsScreen extends StatefulWidget {
  final ReportModel? reportModel;
  final int? announcementId;

  ReportDetailsScreen({Key? key, this.reportModel, this.announcementId})
      : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ReportProvider _reportProvider;
  late AccountProvider _studentProvider;
  bool isLoading = true;
  SearchResult<AccountModel>? students;
  dynamic currentUser = null;

  List<String> _presentStudents = [];
  List<String> _absentStudents = [];

  @override
  void initState() {
    super.initState();
    _reportProvider = context.read<ReportProvider>();
    _studentProvider = context.read<AccountProvider>();
    _initialValue = {
      'notes': widget.reportModel?.notes,
      'goal': widget.reportModel?.goal,
      'volunteerActivities': widget.reportModel?.volunteerActivities,
      'mentor': widget.reportModel?.mentor != null
          ? "${widget.reportModel?.mentor?.firstName} ${widget.reportModel?.mentor?.lastName}"
          : "",
      'themes': widget.reportModel?.themes,
      'presentStudents': widget.reportModel?.presentStudents
              ?.map((student) => student.id.toString())
              .toList() ??
          [],
      'absentStudents': widget.reportModel?.absentStudents
              ?.map((student) => student.id.toString())
              .toList() ??
          [],
    };

    _presentStudents = (_initialValue['presentStudents'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    _absentStudents = (_initialValue['absentStudents'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    initForm();
  }

  Future<void> initForm() async {
    currentUser = await _studentProvider.getCurrentUser();
    students = await _studentProvider.getStudentsForMentor(currentUser.nameid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Report details",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading ? CircularProgressIndicator() : _buildForm(),
            SizedBox(height: 20),
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
          if (widget.reportModel?.status?.name == 'Rejected' &&
              widget.reportModel?.reason != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Reason for rejection: ${widget.reportModel?.reason}",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Notes"),
            name: "notes",
            validator: FormBuilderValidators.required(
              errorText: 'Notes is required',
            ),
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Goal"),
            name: "goal",
            validator: FormBuilderValidators.required(
              errorText: 'Goal is required',
            ),
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Volunteer activities"),
            name: "volunteerActivities",
            validator: FormBuilderValidators.required(
              errorText: 'Volunteer activities is required',
            ),
          ),
          SizedBox(height: 10),
          FormBuilderTextField(
            decoration: InputDecoration(labelText: "Themes"),
            name: "themes",
            validator: FormBuilderValidators.required(
              errorText: 'Themes is required',
            ),
          ),
          SizedBox(height: 10),
          FormBuilderFilterChip(
            name: 'presentStudents',
            decoration: InputDecoration(labelText: "Present Students"),
            initialValue: _presentStudents,
            options: students!.result
                .where((student) =>
                    !_absentStudents.contains(student.id.toString()))
                .map((student) => FormBuilderChipOption<dynamic>(
                      value: student.id.toString(),
                      child: Text("${student.firstName} ${student.lastName}"),
                    ))
                .toList(),
            spacing: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'At least one student must be selected';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _presentStudents = value?.map((e) => e.toString()).toList() ?? [];
              });
            },
          ),
          SizedBox(height: 10),
          FormBuilderFilterChip(
            name: 'absentStudents',
            decoration: InputDecoration(labelText: "Absent Students"),
            initialValue: _absentStudents,
            options: students!.result
                .where((student) =>
                    !_presentStudents.contains(student.id.toString()))
                .map((student) => FormBuilderChipOption<dynamic>(
                      value: student.id.toString(),
                      child: Text("${student.firstName} ${student.lastName}"),
                    ))
                .toList(),
            spacing: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'At least one student must be selected';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _absentStudents = value?.map((e) => e.toString()).toList() ?? [];
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    List<Widget> buttons = [];

    if (widget.reportModel == null) {
      buttons.add(_buildSaveButton());
    } else {
      switch (widget.reportModel!.status?.name) {
        case 'On hold':
          buttons.add(_buildSaveButton());
          break;
        case 'Approved':
          buttons.add(_buildInfoText("This report is approved"));
          break;
        case 'Rejected':
          buttons.add(_buildCorrectReportButton());
          break;
        default:
          buttons.add(_buildSaveButton());
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column( // Wrap buttons in a Column
          children: buttons,
        ),
      ],
    );
  }

  Widget _buildCorrectReportButton() {
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
                'goal': formValue['goal'],
                'volunteerActivities': formValue['volunteerActivities'],
                'themes': formValue['themes'],
                'mentorId': currentUser.nameid,
                'presentStudentsIds': formValue['presentStudents'],
                'absentStudentsIds': formValue['absentStudents'],
                'volunteeringAnnouncementId': this.widget.announcementId
              };
              await _reportProvider.update(widget.reportModel!.id!, request);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReportListScreen()));
            } on Exception catch (e) {
              _showErrorDialog(e.toString());
            }
          }
        },
        child: Text("Correct Report"),
      ),
    );
  }

  Widget _buildInfoText(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Text(
          message,
          softWrap: true,
        ),
      ),
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
                'goal': formValue['goal'],
                'volunteerActivities': formValue['volunteerActivities'],
                'themes': formValue['themes'],
                'mentorId': currentUser.nameid,
                'presentStudentsIds': formValue['presentStudents'],
                'absentStudentsIds': formValue['absentStudents'],
                'volunteeringAnnouncementId': this.widget.announcementId as int
              };
              if (widget.reportModel == null) {
                await _reportProvider.insert(request);
              } else {
                await _reportProvider.update(widget.reportModel!.id!, request);
              }

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReportListScreen()));
            } on Exception catch (e) {
              _showErrorDialog(e.toString());
            }
          }
        },
        child: Text("Save"),
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
