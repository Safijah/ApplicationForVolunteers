import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/report/report.dart';
import 'package:radvolontera_admin/providers/report_provider.dart';
import 'package:radvolontera_admin/screens/reports/report_list_screen.dart';

import '../../widgets/master_screen.dart';

class ReportDetailsScreen extends StatefulWidget {
  ReportModel? reportModel;
  ReportDetailsScreen({Key? key, this.reportModel}) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ReportProvider _reportProvider;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'notes': widget.reportModel?.notes,
      'goal': widget.reportModel?.goal,
      'volunteerActivities': widget.reportModel?.volunteerActivities,
      'mentor': widget.reportModel?.mentor != null
          ? "${widget.reportModel?.mentor?.firstName} ${widget.reportModel?.mentor?.lastName}"
          : "",
      'themes': widget.reportModel?.themes,
    };

    _reportProvider = context.read<ReportProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
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
                        try {
                           var request ={
                            'reportId': widget.reportModel?.id,
                            'status':"Approved"
                          };
                         await  _reportProvider.changeStatus(request);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ReportListScreen()));
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
                    },
                    child: Text("Accept")),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () async {
                        try {
                          var request ={
                            'reportId': widget.reportModel?.id,
                            'status':"Rejected"
                          };
                          await  _reportProvider.changeStatus(request);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ReportListScreen()));
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
                      
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Set the background color to red
                    ),
                    child: Text("Decline")),
              )
            ],
          )
        ],
      ),
      title: "Report details",
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
                        decoration: InputDecoration(labelText: "Notes"),
                        name: "notes",
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Goal"),
                        name: "goal",
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration:
                            InputDecoration(labelText: "Volunteer activities"),
                        name: "volunteerActivities",
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Mentor"),
                        name: "mentor",
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Themes"),
                        name: "themes",
                      ),
                      SizedBox(height: 10),
                      if (widget.reportModel?.absentStudents != null &&
                          widget.reportModel!.absentStudents!.isNotEmpty)
                        Text(
                          "Absent Students: ${widget.reportModel?.absentStudents?.map((student) => "${student.firstName} ${student.lastName}").join(", ")}",
                          style: TextStyle(fontSize: 15),
                        ),
                      SizedBox(height: 10),
                      // Display present students if available
                      if (widget.reportModel?.presentStudents != null &&
                          widget.reportModel!.presentStudents!.isNotEmpty)
                        Text(
                          "Present Students: ${widget.reportModel?.presentStudents?.map((student) => "${student.firstName} ${student.lastName}").join(", ")}",
                          style: TextStyle(fontSize: 15),
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
