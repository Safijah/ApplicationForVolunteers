


import 'dart:convert';

import 'package:radvolontera_mobile/models/monitoring/monitoring.dart';
import 'package:radvolontera_mobile/models/search_result.dart';

import '../models/notification/notification.dart';
import 'base_provider.dart';

class MonitoringProvider extends BaseProvider<MonitoringModel>{
    @override
  MonitoringModel fromJson(data) {
    // TODO: implement fromJson
    return MonitoringModel.fromJson(data);
  } 

  String? _mainBaseUrl;
   String _endpoint = "Monitoring";

  MonitoringProvider() : super("Monitoring"){
    _mainBaseUrl = const String.fromEnvironment("mainBaseUrl", defaultValue: "http://10.0.2.2:7005/api/"); 
  }

  Future<SearchResult<MonitoringModel>> getData({dynamic filter}) async {
  var url = "${_mainBaseUrl}Monitoring";
  if (filter != null) {
    var queryString = getQueryString(filter);
    url = "$url?$queryString";
  }

  var uri = Uri.parse(url);
  var headers = createAuthorizationHeaders();

  var response = await http!.get(uri, headers: headers);
  if (isValidResponse(response)) {
    var data = jsonDecode(response.body);
     var result = SearchResult<MonitoringModel>();
      for (var item in data) {
        result.result.add(fromJson(item));
      }
    // Map each item to MonitoringModel
    return result;
  } else {
    throw Exception("Unknown error");
  }
}

}