


import 'dart:convert';

import 'package:radvolontera_admin/models/payment/payment.dart';
import 'package:http/http.dart' as http;
import '../models/payment/payment_report.dart';
import 'base_provider.dart';

class PaymentProvider extends BaseProvider<PaymentModel>{
 PaymentProvider(): super("Payment");
static String? baseUrl="https://localhost:7264/api";

    @override
  PaymentModel fromJson(data) {
    // TODO: implement fromJson
    return PaymentModel.fromJson(data);
  } 

   Future<List<PaymentReportModel>> getPaymentReport({dynamic filter}) async {
  var url = "$baseUrl/Payment/payment-report";
  if (filter != null) {
    var queryString = getQueryString(filter);
    url = "$url?$queryString";
  }

  var uri = Uri.parse(url);
  var headers = createHeaders();

  var response = await http.get(uri, headers: headers);
  if (isValidResponse(response)) {
    var data = jsonDecode(response.body);

   var result = <PaymentReportModel>[];

    for (var item in data) {
      result.add(PaymentReportModel.fromJson(item));
    }
    return result;
  } else {
    throw new Exception("Unknown error");
  }
}

}