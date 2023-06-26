import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../utils/util.dart';

class AccountProvider with ChangeNotifier{
  static String ? _baseUrl;
  String endpoint = "Account";
  AccountProvider(){
    _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "https://localhost:7264/api/");
  }

  Future<dynamic> login(dynamic body) async {
    var url = "$_baseUrl$endpoint/authenticate";
     var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(body);
    var headers = createHeaders();
   var response = await http.post(
   uri,
   headers: headers,
    body: jsonRequest
  );
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
      throw new Exception("Login incorrect");
    }
  }
  
  Map<String, String> createHeaders(){
     var headers= {
      "Content-Type":"application/json",
      "accept":" application/json"
     };
     return headers;
  }
}