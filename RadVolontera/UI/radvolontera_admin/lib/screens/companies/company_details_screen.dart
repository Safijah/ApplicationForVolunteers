


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/city/city.dart';
import 'package:radvolontera_admin/models/company/company.dart';
import 'package:radvolontera_admin/models/company_category/company_category.dart';
import 'package:radvolontera_admin/providers/city_provider.dart';
import 'package:radvolontera_admin/providers/company_category_provider.dart';
import 'package:radvolontera_admin/providers/company_provider.dart';
import 'package:radvolontera_admin/screens/companies/company_list_screen.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';

class CompanyDetailsScreen extends StatefulWidget {
  CompanyModel? company;
  CompanyDetailsScreen({Key? key,  this.company}) : super(key: key);

  @override
  State<CompanyDetailsScreen> createState() =>
      _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CompanyProvider _companyProvider;
  late CityProvider _cityProvider;
  late CompanyCategoryProvider _companyCategoryProvider;
  SearchResult<CityModel>? cityResults;
   SearchResult<CompanyCategoryModel>? companyCategoryResults;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'name': widget.company?.name,
      'address': widget.company?.address,
      'phoneNumber': widget.company?.phoneNumber,
      'email': widget.company?.email,
      'cityId': widget.company?.cityId.toString(),
      'companyCategoryId': widget.company?.companyCategoryId.toString()
    };

    _companyProvider = context.read<CompanyProvider>();
    _cityProvider = context.read<CityProvider>();
     _companyCategoryProvider = context.read<CompanyCategoryProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future initForm() async {
    cityResults = await _cityProvider.get();
    companyCategoryResults= await _companyCategoryProvider.get();
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
                          if (widget.company == null) {
                            await _companyProvider
                                .insert(_formKey.currentState?.value);
                          } else {
                            await _companyProvider.update(widget.company!.id!,
                               _formKey.currentState?.value);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CompanyListScreen()));
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
              ),
              ElevatedButton(
              onPressed: () {
                // Show delete confirmation dialog here
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Delete"),
                      content: Text("Are you sure you want to delete this company?"),
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
                              if (widget.company != null) {
                                await _companyProvider.delete(widget.company!.id!);
                               Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pop();
                   await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyListScreen(),
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
                primary: Colors.red, // Set button color to red
              ),
              child: Text("Delete"),
            ),
            ],
          )
        ],
      ),
      title: "Company details",
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
          child: SingleChildScrollView(
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
                        Row(
                          children: [
                            Expanded(
                              child:  FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Name"),
                        name: "name",
                        validator: FormBuilderValidators.required(
                          errorText: 'Name is required',
                        ),
                      ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child:  FormBuilderTextField(
                        decoration: InputDecoration(
                            labelText: "Address"),
                        name: "address",
                        validator: FormBuilderValidators.required(
                          errorText: 'Address is required',
                        ),
                      ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                decoration: InputDecoration(labelText: "Email"),
                                name: "email",
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: 'Email is required',
                                  ),
                                  FormBuilderValidators.email(
                                    errorText:
                                        'Please insert valid email format',
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderTextField(
                                decoration:
                                    InputDecoration(labelText: "Phone number"),
                                name: "phoneNumber",
                                validator: FormBuilderValidators.required(
                                  errorText: 'Phone number is required',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'cityId',
                                decoration: InputDecoration(
                                  labelText: 'City',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['cityId']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select city',
                                ),
                                items: cityResults
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
                                  errorText: 'City is required',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'companyCategoryId',
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  suffix: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      _formKey.currentState!.fields['companyCategoryId']
                                          ?.reset();
                                    },
                                  ),
                                  hintText: 'Select category',
                                ),
                                items: companyCategoryResults
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
                                  errorText: 'Month is required',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
