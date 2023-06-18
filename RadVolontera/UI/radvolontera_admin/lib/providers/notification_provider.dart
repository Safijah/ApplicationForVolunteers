import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/util.dart';
class NotificationProvider with ChangeNotifier{
  static String ? _baseUrl;
  String endpoint = "Notification";
  NotificationProvider(){
    _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "https://localhost:7264/api/");
  }

  Future<dynamic> get() async {
    var url = "$_baseUrl$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();
   var response = await  http.get(uri, headers: headers);
    if(isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw new Exception("Unknown error");
    }
  }

  bool isValidResponse(Response response) {
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
    print(token);
     var headers= {
      "Content-Type":"application/json",
      "Authorization": token
     };
     return headers;
  }
}