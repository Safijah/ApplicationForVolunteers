


import 'package:radvolontera_admin/models/payment/payment.dart';

import 'base_provider.dart';

class PaymentProvider extends BaseProvider<PaymentModel>{
 PaymentProvider(): super("Payment");
      
    @override
  PaymentModel fromJson(data) {
    // TODO: implement fromJson
    return PaymentModel.fromJson(data);
  } 
}