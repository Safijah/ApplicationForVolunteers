import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import 'package:radvolontera_mobile/models/fit_pasos/fit_pasos.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/fit_pasos_provider.dart';
import 'package:radvolontera_mobile/screens/fit_pasos/frmPasosi.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';

class FITPasosDetailsScreen extends StatefulWidget {
  FITPasosModel? fitPasos;
  FITPasosDetailsScreen({Key? key, this.fitPasos}) : super(key: key);

  @override
  State<FITPasosDetailsScreen> createState() => _FITPasosDetailsScreenState();
}

class _FITPasosDetailsScreenState extends State<FITPasosDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late FitPasosProvider _fitPasosProvider;
  late AccountProvider _accountProvider;
  SearchResult<AccountModel>? userResult;
  bool isLoading = true;
  bool isValid = false; 
  @override
  void initState() {
    super.initState();
    _initialValue = {
      'isValid': widget.fitPasos?.isValid,
      'userId': widget.fitPasos?.userId,
      'datumIzdavanja': widget.fitPasos?.datumIzdavanja,
    };
     
    _fitPasosProvider = context.read<FitPasosProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  Future initForm() async {
    userResult = await _accountProvider.get();
    setState(() {
      isLoading = false;
      isValid = widget.fitPasos != null ? widget.fitPasos!.isValid : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Column(
        children: [
          isLoading ? CircularProgressIndicator() : _buildForm(),
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
                            'datumIzdavanja': formValue!['datumIzdavanja'].toIso8601String(),
                            'userId': formValue['userId'],
                            'isValid': isValid
                          };
                          if (widget.fitPasos == null) {
                            await _fitPasosProvider
                                .insert(request);
                          } else {
                            await _fitPasosProvider.update(widget.fitPasos!.id!,
                               request);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const FITPasosiListScreen()));
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
              if (widget.fitPasos != null) ...[
              ]
            ],
          )
        ],
      ),
      title: "FIT pasos detalji",
      showBackButton: true,
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
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          name: 'userId',
                          decoration: InputDecoration(
                            labelText: 'User',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _formKey.currentState!.fields['userId']
                                    ?.reset();
                              },
                            ),
                            hintText: 'Select user',
                          ),
                          items: userResult?.result
                                  .map(
                                    (item) => DropdownMenuItem(
                                      alignment: AlignmentDirectional.center,
                                      value: item.id.toString(),
                                      child: Text(item.fullName ?? ""),
                                    ),
                                  )
                                  .toList() ??
                              [],
                          validator: FormBuilderValidators.required(
                            errorText: 'User is required',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                      Expanded(
                        child: FormBuilderDateTimePicker(
                                name: 'datumIzdavanja',
                                decoration: InputDecoration(
                                  labelText: 'Datum izdavanja',
                                ),
                                initialEntryMode: DatePickerEntryMode.calendar,
                                inputType: InputType.date,
                                format: DateFormat('dd-MM-yyyy'),
                                validator: FormBuilderValidators.required(
                                  errorText: 'Datum izdavanja is required',
                                ),
                              ),
                      ),
                  ],
                  ),
                  SizedBox(height: 10),
                  Row(
              children: [
                Checkbox(
                  value: isValid,
                  onChanged: (bool? value) {
                    setState(() {
                      isValid = value ?? false;
                    });
                  },
                ),
                Text('Is Valid'),
              ],
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
