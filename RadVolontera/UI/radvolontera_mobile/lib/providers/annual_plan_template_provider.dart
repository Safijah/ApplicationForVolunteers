
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radvolontera_mobile/models/annual_template_plan/annual_plan_template.dart';
import 'package:radvolontera_mobile/providers/base_provider.dart';
class AnnualPlanTemplateProvider extends BaseProvider<AnnualPlanTemplateModel>{
 AnnualPlanTemplateProvider(): super("AnnualPlanTemplate");
      
    @override
  AnnualPlanTemplateModel fromJson(data) {
    // TODO: implement fromJson
    return AnnualPlanTemplateModel.fromJson(data);
  } 

  Future<List<String>> getAvailableYears() async {
    var url = "${BaseProvider.baseUrl}AnnualPlanTemplate/available-years";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      // Convert dynamic list to List<String>
      return List<String>.from(data.map((item) => item.toString()));
    } else {
      throw Exception("Unknown error");
    }
  }
}