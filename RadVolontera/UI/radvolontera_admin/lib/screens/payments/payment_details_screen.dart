import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/providers/payment_provider.dart';
import 'package:radvolontera_admin/screens/payments/payment_list_screen.dart';

import '../../models/payment/payment.dart';
import '../../models/search_result.dart';
import '../../providers/account_provider.dart';
import '../../widgets/master_screen.dart';

class PaymentDetailsScreen extends StatefulWidget {
  PaymentModel? payment;
  PaymentDetailsScreen({Key? key, this.payment}) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() =>
      _PaymentDetailsScreenScreenState();
}

class _PaymentDetailsScreenScreenState extends State<PaymentDetailsScreen> {
  List<DropdownItem> dropdownItems = [
    DropdownItem(1, 'January'),
    DropdownItem(2, 'February'),
    DropdownItem(3, 'March'),
    DropdownItem(4, 'April'),
    DropdownItem(5, 'May'),
    DropdownItem(6, 'June'),
    DropdownItem(7, 'July'),
    DropdownItem(8, 'August'),
    DropdownItem(9, 'September'),
    DropdownItem(10, 'October'),
    DropdownItem(11, 'November'),
    DropdownItem(12, 'December'),
  ];
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late PaymentProvider _paymentProvider;
  late AccountProvider _accountProvider;
  SearchResult<AccountModel>? studentsResult;
  bool isLoading = true;
  dynamic currentUser = null;
  @override
  void initState() {
    super.initState();
    _initialValue = {
      'notes': widget.payment?.notes,
      'amount': widget.payment?.amount.toString(),
      'month': widget.payment?.month?.toString(),
      'year': widget.payment?.year.toString(),
      'studentId': widget.payment?.studentId.toString()
    };

    _paymentProvider = context.read<PaymentProvider>();
    _accountProvider = context.read<AccountProvider>();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    studentsResult = await _accountProvider.get(filter: {
      'userTypes': 3,
    });
    currentUser = await _accountProvider.getCurrentUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
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
                        var formValue = _formKey.currentState?.value;
                        var request = {
                          'notes': formValue!['notes'],
                          'amount': formValue['amount'],
                          'studentId': formValue['studentId'],
                          'month': int.tryParse(formValue['month']),
                          'year': formValue['year']
                        };
                        if (widget.payment == null) {
                          await _paymentProvider.insert(request);
                        } else {
                          await _paymentProvider.update(widget.payment!.id!, request);
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PaymentListScreen()));
                      } on Exception catch (e) {
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
                  },
                  child: Text("Save"),
                ),
              ),
              if(widget.payment != null)
              ...[
           ElevatedButton(
              onPressed: () {
                // Show delete confirmation dialog here
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Delete"),
                      content: Text("Are you sure you want to delete this payment?"),
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
                              if (widget.payment != null) {
                                await _paymentProvider.delete(widget.payment!.id!);
                               Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pop();
                   await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentListScreen(),
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
                foregroundColor: Colors.white,//change background color of button
                backgroundColor: Colors.red,
              ),
              child: Text("Delete"),
            ),
            ]
            ],
          ),
        ],
      ),
      title: "Payment details",
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
                        validator: FormBuilderValidators.required(
                          errorText: 'Notes is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                            labelText: "Amount", hintText: "Enter numbers only"),
                        name: "amount",
                        validator: FormBuilderValidators.required(
                          errorText: 'Amount is required',
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                      SizedBox(height: 10),
                      FormBuilderDropdown<String>(
                        name: 'studentId',
                        decoration: InputDecoration(
                          labelText: 'Student',
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['studentId']?.reset();
                            },
                          ),
                          hintText: 'Select student',
                        ),
                        items: studentsResult?.result
                                ?.map(
                                  (item) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: item.id.toString(),
                                    child: Text('${item.firstName} ${item.lastName}'),
                                  ),
                                )
                                .toList() ??
                            [],
                        validator: FormBuilderValidators.required(
                          errorText: 'Student is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDropdown<String>(
                        name: 'month',
                        decoration: InputDecoration(
                          labelText: 'Month',
                          suffix: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['month']?.reset();
                            },
                          ),
                          hintText: 'Select month',
                        ),
                        items: dropdownItems
                                .map(
                                  (item) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: item.value.toString(),
                                    child: Text(item.displayText ?? ""),
                                  ),
                                )
                                .toList() ??
                            [],
                        validator: FormBuilderValidators.required(
                          errorText: 'Month is required',
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Year",
                          hintText: "1234",
                        ),
                        name: "year",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Year is required'),
                          FormBuilderValidators.numeric(
                              errorText: 'Enter a valid year'),
                          (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length != 4) {
                              return 'Enter year';
                            }
                            return null;
                          },
                        ]),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                      )
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
