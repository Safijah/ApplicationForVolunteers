import 'dart:convert';

import 'package:radvolontera_mobile/models/company_event/company_event.dart';
import 'package:radvolontera_mobile/models/search_result.dart';

import 'base_provider.dart';

class CompanyEventProvider extends BaseProvider<CompanyEventModel>{
 CompanyEventProvider(): super("CompanyEvent");
      
    @override
  CompanyEventModel fromJson(data) {
    // TODO: implement fromJson
    return CompanyEventModel.fromJson(data);
  } 

  Future<void> registerForEvent( [dynamic request]) async {
    var url = "${BaseProvider.baseUrl}CompanyEvent/register-for-event";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    if (!isValidResponse(response)) {
      throw new Exception("Unknown error");
    }
  }

  Future<bool> check([dynamic request]) async {
    var url = "${BaseProvider.baseUrl}CompanyEvent/is-registered";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      // Convert dynamic list to List<String>
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<SearchResult<CompanyEventModel>> recommended([dynamic request]) async {
    var url = "${BaseProvider.baseUrl}CompanyEvent/reccomended";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      // Convert dynamic list to List<String>
      var result = SearchResult<CompanyEventModel>();
      for (var item in data) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }
}