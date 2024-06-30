import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:radvolontera_mobile/utils/util.dart';

 class MonitoringProvider<MonitoringModel> with ChangeNotifier {
  static String baseUrl = const String.fromEnvironment("baseUrl",defaultValue:"https://10.0.2.2:7102/api/");
  HttpClient client = new HttpClient();
  IOClient? http;
  MonitoringProvider() {
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<List<MonitoringModel>> get({dynamic filter}) async {
    var url = "${baseUrl}Monitoring";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      // Convert dynamic list to List<String>
      return List<MonitoringModel>.from(data.map((item) => item));
    } else {
      throw new Exception("Unknown error");
    }
  }


  bool isValidResponse(Response response) {
    print("response ${response.body}");
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      throw new Exception("Something bad happened please try again");
    }
  }

   
  Map<String, String> createHeaders(){
    String token="Bearer ${Authorization.token}";
     var headers= {
      "Content-Type":"application/json",
      "Authorization": token
     };
     return headers;
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

  String getQueryString(Map params,
      {String prefix= '&', bool inRecursion= false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

}