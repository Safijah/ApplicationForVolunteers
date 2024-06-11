import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/company_category/company_category.dart';
import 'package:radvolontera_admin/providers/company_category_provider.dart';

import '../../widgets/master_screen.dart';
import 'company_category_list_screen.dart';

class CompanyCategoryDetailsScreen extends StatefulWidget {
  CompanyCategoryModel? companyCategory;
  CompanyCategoryDetailsScreen({Key? key, this.companyCategory})
      : super(key: key);

  @override
  State<CompanyCategoryDetailsScreen> createState() =>
      _CompanyCategoryDetailsScreenState();
}

class _CompanyCategoryDetailsScreenState
    extends State<CompanyCategoryDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late CompanyCategoryProvider _companyCategoryProvider;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'name': widget.companyCategory?.name,
      'id': widget.companyCategory?.id,
    };

    _companyCategoryProvider = context.read<CompanyCategoryProvider>();
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
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                           var request = {
                              'name': _formKey
                                .currentState?.instantValue.values.first,
                            };
                          if (widget.companyCategory == null) {
                            await _companyCategoryProvider.insert(request);
                          } else {
                            await _companyCategoryProvider.update(
                                widget.companyCategory!.id!,
                               request);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const CompanyCategoryListScreen()));
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
            ],
          )
        ],
      ),
      title: this.widget.companyCategory?.name ?? "Company category details",
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
                        decoration: InputDecoration(labelText: "Name"),
                        name: "name",
                        validator: FormBuilderValidators.required(
                          errorText: 'Name is required',
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
