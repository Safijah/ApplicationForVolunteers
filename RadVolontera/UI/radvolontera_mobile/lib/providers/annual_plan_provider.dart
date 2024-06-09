
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:radvolontera_mobile/models/annual_plan/annual_plan.dart';
import 'package:radvolontera_mobile/providers/base_provider.dart';
class AnnualPlanProvider extends BaseProvider<AnnualPlanModel>{
 AnnualPlanProvider(): super("AnnualPlan");
      
    @override
  AnnualPlanModel fromJson(data) {
    // TODO: implement fromJson
    return AnnualPlanModel.fromJson(data);
  } 
 IOClient? http; // Use the IOClient for making HTTP requests
  Future<List<String>> getAvailableYears(String mentorId) async {
    var url = "${BaseProvider.baseUrl}AnnualPlan/available-years/$mentorId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      // Convert dynamic list to List<String>
      return List<String>.from(data.map((item) => item.toString()));
    } else {
      throw Exception("Unknown error");
    }
  }

    AnnualPlanProvider.withHttpClient()
      : super("AnnualPlan") {
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }
}