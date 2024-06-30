import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/annual_plan_template/annual_plan_template.dart';
import 'package:radvolontera_admin/providers/annual_plan_template_provider.dart';
import 'package:radvolontera_admin/screens/annual_plan_templates/annual_plan_template_list_screen.dart';
import 'package:radvolontera_admin/widgets/master_screen.dart';

class AnnualPlanTemplateDetailsScreen extends StatefulWidget {
  final AnnualPlanTemplateModel? annualPlanTemplateModel;

  AnnualPlanTemplateDetailsScreen({Key? key, this.annualPlanTemplateModel})
      : super(key: key);

  @override
  _AnnualPlanTemplateDetailsScreenState createState() =>
      _AnnualPlanTemplateDetailsScreenState();
}

class _AnnualPlanTemplateDetailsScreenState
    extends State<AnnualPlanTemplateDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late AnnualPlanTemplateProvider _annualPlanTemplateProvider;
  List<String> availableYears = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _annualPlanTemplateProvider = context.read<AnnualPlanTemplateProvider>();
    initForm();
  }

  Future<void> initForm() async {
    try {
      availableYears = await _annualPlanTemplateProvider.getAvailableYears();
      setState(() {
        isLoading = false;
        if (widget.annualPlanTemplateModel != null) {
          _initialValue = {
            'year': widget.annualPlanTemplateModel!.year.toString(),
            ...widget.annualPlanTemplateModel!.monthlyPlanTemplates
                .asMap()
                .map((index, item) => MapEntry(
                      'month_${item.month}',
                      item.theme ?? '',
                    ))
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildForm(),
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
                if (widget.annualPlanTemplateModel != null)
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: _showDeleteConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Colors.white, //change background color of button
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
      title: "Annual Plan Template Details",
      showBackButton: true,
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
            if (widget.annualPlanTemplateModel == null)
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
                  validator: FormBuilderValidators.required(
                      errorText: 'Year is required'),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Annual template for ${widget.annualPlanTemplateModel!.year} year',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ...List.generate(12, (index) {
              int month = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          getMonthName(month),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: FormBuilderTextField(
                          name: 'month_$month',
                          decoration: InputDecoration(
                            labelText: 'Theme for ${getMonthName(month)}',
                            hintText: 'Enter theme',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: FormBuilderValidators.required(
                              errorText: 'Theme is required'),
                        ),
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
        List<dynamic> monthlyPlanTemplates = [];
        for (int month = 1; month <= 12; month++) {
          monthlyPlanTemplates.add({
            'month': month,
            'theme': formValue?['month_$month'],
            'monthName': getMonthName(month),
          });
        }
        var request = {
          'year':this.widget.annualPlanTemplateModel?.year ?? formValue!['year'] ,
          'monthlyPlanTemplates': monthlyPlanTemplates,
        };
        if (widget.annualPlanTemplateModel == null) {
          await _annualPlanTemplateProvider.insert(request);
        } else {
          await _annualPlanTemplateProvider.update(
              widget.annualPlanTemplateModel!.id!, request);
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AnnualPlanTemplateListscreen()));
      } catch (e) {
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
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete this annual plan template?"),
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
                  if (widget.annualPlanTemplateModel != null) {
                    await _annualPlanTemplateProvider
                        .delete(widget.annualPlanTemplateModel!.id!);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnualPlanTemplateListscreen(),
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
                          child: Text("OK"),
                        ),
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
