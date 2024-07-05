import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:radvolontera_mobile/models/company_event/company_event.dart';
import 'package:radvolontera_mobile/providers/account_provider.dart';
import 'package:radvolontera_mobile/providers/company_event_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:radvolontera_mobile/screens/company_events/company_events_details_screen.dart';
import 'package:radvolontera_mobile/screens/company_events/company_events_list_screen.dart';
class PaymentScreen extends StatefulWidget {
  final CompanyEventModel? companyEvent;

  const PaymentScreen({Key? key, this.companyEvent}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      onCreditCardModelChange: onCreditCardModelChange,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber, // Required
                      expiryDate: expiryDate, // Required
                      cardHolderName: cardHolderName, // Required
                      cvvCode: cvvCode, // Required
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          bool paymentSuccess = await _makePayment();
                          if (paymentSuccess) {
                            _registerForEvent(context);
                          } else {
                            _showPaymentErrorDialog(context);
                          }
                        } else {
                          _showValidationErrorDialog(context);
                        }
                      },
                      child: Text('Pay Now'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<bool> _makePayment() async {
    // Implement your Stripe payment logic here
    // Return true for successful payment, false for failure
    try {
 List<String> parts = expiryDate.split('/');

    var _companyEventProvider = context.read<CompanyEventProvider>();
    var request = {
      'cardNumber': cardNumber,
      'month': parts[0],
      'year': parts[1],
      'cvc': cvvCode,
      'cardHolderName': cardHolderName,
      'totalPrice': widget.companyEvent?.price ?? 0
    };
    var result =await _companyEventProvider.pay(request);
    return result; // Placeholder, replace with actual Stripe integration
    } on Exception catch (e) {
         return false;
    }
  }

  void _registerForEvent(BuildContext context) async {
    // Call the registration method from the provider
    try {
      var _companyEventProvider = context.read<CompanyEventProvider>();
      var currentUser = await context.read<AccountProvider>().getCurrentUser();
      await _companyEventProvider.registerForEvent({
        'companyEventId': widget.companyEvent!.id!,
        'mentorId': currentUser.nameid,
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Success"),
          content: Text("You have successfully registered for the event."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CompanyEventDetailsScreen(companyEvent: widget.companyEvent))),
              child: Text("OK"),
            ),
          ],
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

  void _showPaymentErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Payment Error"),
        content: Text("There was an error processing your payment."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showValidationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Validation Error"),
        content: Text("Please ensure all fields are filled out correctly."),
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

