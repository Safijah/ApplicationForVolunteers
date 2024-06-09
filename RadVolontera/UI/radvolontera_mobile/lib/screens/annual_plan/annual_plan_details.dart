import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/annual_plan/annual_plan.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/annual_plan_provider.dart';
import 'package:radvolontera_mobile/providers/annual_plan_template_provider.dart';
import 'package:radvolontera_mobile/screens/annual_plan/annual_plan_list_screen.dart';
import 'package:radvolontera_mobile/widgets/master_screen.dart';

class AnnualPlanDetailsScreen extends StatefulWidget {
  final AnnualPlanModel? annualPlanModel;

  AnnualPlanDetailsScreen({Key? key, this.annualPlanModel}) : super(key: key);

  @override
  _AnnualPlanDetailsScreenState createState() => _AnnualPlanDetailsScreenState();
}

class _AnnualPlanDetailsScreenState extends State<AnnualPlanDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AnnualPlanProvider _annualPlanProvider;
  late AnnualPlanTemplateProvider _annualPlanTemplateProvider;
  List<String> availableYears = [];
  bool isLoading = true;
  int? annualPlanTemplateId=0;
  late AccountProvider _accountProvider;
  dynamic currentUser = null;
  Map<int, String> _templateThemes = {};
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    _annualPlanProvider = context.read<AnnualPlanProvider>();
    _annualPlanTemplateProvider = context.read<AnnualPlanTemplateProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  Future<void> initForm() async {
    try {
      currentUser = await _accountProvider.getCurrentUser();
      availableYears = await _annualPlanProvider.getAvailableYears(this.currentUser.nameid);
      if (widget.annualPlanModel != null) {
        selectedYear = widget.annualPlanModel!.year.toString();
        await _fetchTemplate(selectedYear!);
      }
      setState(() {
        isLoading = false;
        if (widget.annualPlanModel != null) {
          _initialValue = {
            'year': widget.annualPlanModel!.year.toString(),
            ...widget.annualPlanModel!.monthlyPlans.asMap().map((index, item) => MapEntry(
                  'month_${item.month}_theme1',
                  item.theme1 ?? '',
                )),
            ...widget.annualPlanModel!.monthlyPlans.asMap().map((index, item) => MapEntry(
                  'month_${item.month}_goals1',
                  item.goals1 ?? '',
                )),
            ...widget.annualPlanModel!.monthlyPlans.asMap().map((index, item) => MapEntry(
                  'month_${item.month}_theme2',
                  item.theme2 ?? '',
                )),
            ...widget.annualPlanModel!.monthlyPlans.asMap().map((index, item) => MapEntry(
                  'month_${item.month}_goals2',
                  item.goals2 ?? '',
                )),
          };
        }
      });
    } catch (e) {
      print('Failed to load available years: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchTemplate(String year) async {
    try {
      setState(() {
        isLoading = true;
      });
      var result = await _annualPlanTemplateProvider.get(filter: {'year': year});
      setState(() {
        final list = result.result.first;
        this.annualPlanTemplateId = result.result.first.id;
        _templateThemes = {
          for (var item in list.monthlyPlanTemplates) item.month!: item.theme!,
        };
        _initialValue = {
          'year': year,
          ..._templateThemes.map((month, theme) => MapEntry(
                'month_${month}_theme1',
                theme,
              )),
        };
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load template: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading ? Center(child: CircularProgressIndicator()) : _buildForm(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text("Save"),
                  ),
                ),
                if (widget.annualPlanModel != null)
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: _showDeleteConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, //change background color of button
                        backgroundColor: Colors.red,
                      ),
                      child: Text("Delete"),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      title: "Annual Plan Details",
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.annualPlanModel == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: FormBuilderDropdown<String>(
                  name: 'year',
                  decoration: InputDecoration(
                    labelText: 'Year',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['year']?.reset();
                      },
                    ),
                    hintText: 'Select year',
                  ),
                  items: availableYears
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  validator: FormBuilderValidators.required(errorText: 'Year is required'),
                  onChanged: (value) {
                    if (value != null) {
                      selectedYear = value;
                      _fetchTemplate(value);
                    }
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Annual plan for ${widget.annualPlanModel!.year} year',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            if (selectedYear != null || widget.annualPlanModel != null) ...List.generate(12, (index) {
              int month = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getMonthName(month),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'month_${month}_theme1',
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Theme 1 for ${getMonthName(month)}',
                          hintText: 'Theme 1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'month_${month}_goals1',
                        decoration: InputDecoration(
                          labelText: 'Goals 1 for ${getMonthName(month)}',
                          hintText: 'Enter goals for theme 1',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: FormBuilderValidators.required(errorText: 'Goals for first theme  are required'),
                      ),
                      SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'month_${month}_theme2',
                        decoration: InputDecoration(
                          labelText: 'Second theme for ${getMonthName(month)}',
                          hintText: 'Enter theme 2',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                         validator: FormBuilderValidators.required(errorText: 'Second theme  is required'),
                      ),
                      SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'month_${month}_goals2',
                        decoration: InputDecoration(
                          labelText: 'Goals for second theme for ${getMonthName(month)}',
                          hintText: 'Enter goals for second theme',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: FormBuilderValidators.required(errorText: 'Goals for second theme  are required'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        _formKey.currentState?.saveAndValidate();
        var formValue = _formKey.currentState?.value;
        List<dynamic> monthlyPlans = [];
        for (int month = 1; month <= 12; month++) {
          monthlyPlans.add({
            'month': month,
            'theme1': formValue?['month_${month}_theme1'],
            'goals1': formValue?['month_${month}_goals1'],
            'theme2': formValue?['month_${month}_theme2'],
            'goals2': formValue?['month_${month}_goals2'],
          });
        }
        var request = {
          'year': this.widget.annualPlanModel?.year ?? formValue!['year'],
          'monthlyPlans': monthlyPlans,
          'mentorId':this.currentUser.nameid,
          'annualPlanTemplateId':this.annualPlanTemplateId
        };
        if (widget.annualPlanModel == null) {
          await _annualPlanProvider.insert(request);
        } else {
          await _annualPlanProvider.update(widget.annualPlanModel!.id!, request);
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AnnualPlanListScreen()));
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK")),
                  ],
                ));
      }
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this annual plan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (widget.annualPlanModel != null) {
                    await _annualPlanProvider.delete(widget.annualPlanModel!.id!);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnualPlanListScreen(),
                      ),
                    );
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("Error"),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK")),
                      ],
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
