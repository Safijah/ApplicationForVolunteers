import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/company_event/company_event.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/company_event_provider.dart';
import 'package:radvolontera_mobile/screens/company_events/company_events_list_screen.dart';

import '../../widgets/master_screen.dart';

class CompanyEventDetailsScreen extends StatefulWidget {
  final CompanyEventModel? companyEvent;

  CompanyEventDetailsScreen({Key? key, this.companyEvent}) : super(key: key);

  @override
  State<CompanyEventDetailsScreen> createState() =>
      _CompanyEventDetailsScreenState();
}

class _CompanyEventDetailsScreenState extends State<CompanyEventDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AccountProvider _accountProvider;
  late CompanyEventProvider _companyEventProvider;
  bool isLoading = true;
  bool isRegistered = false; // Track the registration status of the user
  dynamic currentUser = null;
  List<CompanyEventModel> recommendedEvents = []; // Store recommended events

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'eventName': widget.companyEvent?.eventName,
      'location': widget.companyEvent?.location,
      'time': widget.companyEvent?.time?.toString(),
      'companyId': widget.companyEvent?.companyId.toString(),
      'eventDate': widget.companyEvent?.eventDate
    };
    _accountProvider = context.read<AccountProvider>();
    _companyEventProvider = context.read<CompanyEventProvider>();
    initForm();
  }

  Future initForm() async {
    // Check if user is registered for this event
    currentUser = await _accountProvider.getCurrentUser();
    isRegistered = await _companyEventProvider.check({
      'companyEventId': widget.companyEvent!.id!,
      'mentorId': currentUser.nameid,
    });

    // Fetch recommended events
    var recommended = await _companyEventProvider.recommended({
      'companyEventId': widget.companyEvent!.id!,
      'mentorId': currentUser.nameid,
    });

    setState(() {
      isLoading = false;
      recommendedEvents = recommended.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime eventDate = widget.companyEvent?.eventDate ?? DateTime.now();

    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? CircularProgressIndicator() : _buildForm(),
          if (widget.companyEvent != null &&
              widget.companyEvent!.eventDate != null &&
              widget.companyEvent!.eventDate!.isAfter(DateTime.now())) ...[
            isRegistered
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("You are registered for this event."),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _showRegistrationDialog();
                      },
                      child: Text("Register for Event"),
                    ),
                  )
          ],
          if (eventDate.isBefore(DateTime.now())) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "This event has passed. Please check for upcoming events.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
          SizedBox(height: 20),
          if (recommendedEvents.isNotEmpty)
            _buildRecommendedEventsList(),
        ],
      ),
      title: "Company event details",
    );
  }

  Future<void> registerForEvent() async {
    // Call the registration method from the provider
    try {
      await _companyEventProvider.registerForEvent({
        'companyEventId': widget.companyEvent!.id!,
        'mentorId': currentUser.nameid,
      });

      setState(() {
        isRegistered = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Success"),
          content: Text("You have successfully registered for the event."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyEventListScreen(),
        ),
      );
    } catch (e) {
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

  void _showRegistrationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Confirm Registration"),
        content: Text("Are you sure you want to register for this event?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              registerForEvent();
            },
            child: Text("Confirm"),
          ),
        ],
      ),
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
                SizedBox(width: 30),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Event name"),
                        name: "eventName",
                        readOnly: true,
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Location"),
                        name: "location",
                        readOnly: true,
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Time",
                          hintText: "HH:mm",
                        ),
                        name: "time",
                        readOnly: true,
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
                        enabled: false,
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

  Widget _buildRecommendedEventsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: recommendedEvents.length,
        itemBuilder: (context, index) {
          var event = recommendedEvents[index];
          return ListTile(
            title: Text(event.eventName ?? ""),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Location: ${event.location ?? ""}"),
                Text("Company: ${event.company?.name ?? ""}"),
                Text("Time: ${event.time ?? ""}"),
                Text("Date: ${DateFormat('dd.MM.yyyy').format(event.eventDate!)}"),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CompanyEventDetailsScreen(companyEvent: event),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
