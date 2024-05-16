


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../models/report/report.dart';
import '../models/search_result.dart';
import '../utils/util.dart';
import 'base_provider.dart';

class ReportProvider extends BaseProvider<ReportModel>{
 ReportProvider(): super("Report");
 static String? baseUrl="https://10.0.2.2:7264/api";
IOClient? http;
    @override
  ReportModel fromJson(data) {
    // TODO: implement fromJson
    return ReportModel.fromJson(data);
  } 


Future< SearchResult< ReportModel>> getReports(String mentorId) async {
    var url = "$baseUrl/Report/student-reports/$mentorId";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
     var data = jsonDecode(response.body);

      var result = SearchResult<ReportModel>();

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

   Map<String, String> createAuthorizationHeaders(){
      String token="Bearer ${Authorization.token}";
     var headers= {
      "Content-Type":"application/json",
       "accept":" application/json",
       "Authorization": token
     };
     return headers;
  }

    // Initialize the IOClient with the custom HttpClient
  ReportProvider.withHttpClient()
      : super("Report") {
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }
}