
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/notification/notification.dart';
import '../models/search_result.dart';
import '../utils/util.dart';
class NotificationProvider with ChangeNotifier{
  static String ? _baseUrl;
  String endpoint = "Notification";
  NotificationProvider(){
    _baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "https://localhost:7264/api/");
  }

  Future<SearchResult<NotificationModel>>  get({dynamic filter}) async {
    
    var url = "$_baseUrl$endpoint";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();
   var response = await  http.get(uri, headers: headers);
    if(isValidResponse(response)) {
      var result = SearchResult<NotificationModel>();
      var data = jsonDecode(response.body);
       result.count = data['count'];
       for(var item in data['result']){
        result.result.add(NotificationModel.fromJson(item));
       }
      return result;
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
     var headers= {
      "Content-Type":"application/json",
      "Authorization": token
     };
     return headers;
  }

   String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
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