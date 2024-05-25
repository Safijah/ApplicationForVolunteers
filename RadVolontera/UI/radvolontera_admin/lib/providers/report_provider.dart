


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radvolontera_admin/models/report/report.dart';

import '../utils/util.dart';
import 'base_provider.dart';

class ReportProvider extends BaseProvider<ReportModel>{
 ReportProvider(): super("Report");
      
    @override
  ReportModel fromJson(data) {
    // TODO: implement fromJson
    return ReportModel.fromJson(data);
  } 
  
  Future<ReportModel> changeStatus([dynamic request]) async {
  var urlGlobal = "${BaseProvider.baseUrl}Report/change-status";
  var uri = Uri.parse(urlGlobal);
  var headers = createAuthorizationHeaders(); // Using createHeaders() method from the base class

  var jsonRequest = jsonEncode(request);
  var response = await http.put(uri, headers: headers, body: jsonRequest);

  if (isValidResponse(response)) { // Using isValidResponse() method from the base class
    var data = jsonDecode(response.body);
    return ReportModel.fromJson(data);
  } else {
    throw new Exception("Unknown error");
  }
}
}