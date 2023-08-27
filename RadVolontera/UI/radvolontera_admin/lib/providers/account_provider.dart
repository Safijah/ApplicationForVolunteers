import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/account/token_info.dart';
import 'package:radvolontera_admin/models/exception_result.dart';

import '../models/search_result.dart';
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

      throw new Exception("Please try again");
    }
  }
  
  Map<String, String> createHeaders(){
     var headers= {
      "Content-Type":"application/json",
      "accept":" application/json"
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

  TokenInfoModel getCurrentUser(){
    Map<String, dynamic> decodedToken = JwtDecoder.decode(Authorization.token!);
    return TokenInfoModel.fromJson(decodedToken);
  }

  Future<SearchResult<AccountModel>> get({dynamic filter}) async {
    var url = "$_baseUrl$endpoint";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<AccountModel>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(AccountModel.fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<AccountModel> insert(dynamic request) async {
    var url = "$_baseUrl$endpoint/register";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<AccountModel> update(String id, [dynamic request]) async {
    var url = "$_baseUrl$endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
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