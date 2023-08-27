

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/volunteering_announcement/volunteering_announcement.dart';
import 'package:radvolontera_admin/providers/volunteering_announcement_provider.dart';
import 'package:radvolontera_admin/screens/volunteering_announcements/volunteering_announcement_list_screen.dart';

import '../../widgets/master_screen.dart';

class VolunteeringAnnouncementDetailsScreen extends StatefulWidget {
  VolunteeringAnnouncementModel? volunteeringAnnouncementModel;
  VolunteeringAnnouncementDetailsScreen({Key? key,  this.volunteeringAnnouncementModel}) : super(key: key);

  @override
  State<VolunteeringAnnouncementDetailsScreen> createState() =>
      _VolunteeringAnnouncementDetailsScreenState();
}

class _VolunteeringAnnouncementDetailsScreenState extends State<VolunteeringAnnouncementDetailsScreen> {
    
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late VolunteeringAnnouncementProvider _volunteeringAnnouncementProvider;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'notes': widget.volunteeringAnnouncementModel?.notes,
      'place': widget.volunteeringAnnouncementModel?.place,
      'city': widget.volunteeringAnnouncementModel?.city?.name,
      'mentor': widget.volunteeringAnnouncementModel?.mentor != null ? "${widget.volunteeringAnnouncementModel?.mentor?.firstName} ${widget.volunteeringAnnouncementModel?.mentor?.lastName}" :"",
      'timeFrom':widget.volunteeringAnnouncementModel?.timeFrom.toString(),
      'timeTo': widget.volunteeringAnnouncementModel?.timeTo.toString(),
      'date': widget.volunteeringAnnouncementModel?.date != null
      ? DateFormat('dd.MM.yyyy').format(widget.volunteeringAnnouncementModel!.date!)
      : '',
    };

    _volunteeringAnnouncementProvider = context.read<VolunteeringAnnouncementProvider>();
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
                            'volunteeringAnnouncementId': widget.volunteeringAnnouncementModel?.id,
                            'status':"Approved"
                          };
                           await _volunteeringAnnouncementProvider.changeStatus(request);
                         Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const VolunteeringAnnouncementListcreen()));
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
                            'volunteeringAnnouncementId': widget.volunteeringAnnouncementModel?.id,
                            'status':"Rejected"
                          };
                        await  _volunteeringAnnouncementProvider.changeStatus(request);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const VolunteeringAnnouncementListcreen()));
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
      title: "Volunteering announcement details",
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
                        decoration: InputDecoration(
                            labelText: "Place"),
                        name: "place",
                      ),
                      SizedBox(height: 10),
                        FormBuilderTextField(
                        decoration: InputDecoration(labelText: "City"),
                        name: "city",
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                            labelText: "Mentor"),
                        name: "mentor",
                      ),
                      SizedBox(height: 10),
                          FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Time from"),
                        name: "timeFrom",
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                            labelText: "Time to"),
                        name: "timeTo",
                      ),
                      SizedBox(height: 10),
                        FormBuilderTextField(
                        decoration: InputDecoration(
                            labelText: "Date"),
                        name: "date",
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
