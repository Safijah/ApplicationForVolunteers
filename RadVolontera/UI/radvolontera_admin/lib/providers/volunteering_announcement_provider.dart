
import 'dart:convert';

import 'package:radvolontera_admin/models/volunteering_announcement/volunteering_announcement.dart';
import 'package:http/http.dart' as http;
import '../utils/util.dart';
import 'base_provider.dart';

class VolunteeringAnnouncementProvider extends BaseProvider<VolunteeringAnnouncementModel>{
 VolunteeringAnnouncementProvider(): super("VolunteeringAnnouncement");
    @override
  VolunteeringAnnouncementModel fromJson(data) {
    // TODO: implement fromJson
    return VolunteeringAnnouncementModel.fromJson(data);
  } 

  Future<VolunteeringAnnouncementModel> changeStatus([dynamic request]) async {
  var urlGlobal = "${BaseProvider.baseUrl}VolunteeringAnnouncement/change-status";
  var uri = Uri.parse(urlGlobal);
  var headers = createAuthorizationHeaders(); // Using createHeaders() method from the base class

  var jsonRequest = jsonEncode(request);
  var response = await http.put(uri, headers: headers, body: jsonRequest);

  if (isValidResponse(response)) { // Using isValidResponse() method from the base class
    var data = jsonDecode(response.body);
    return VolunteeringAnnouncementModel.fromJson(data);
  } else {
    throw new Exception("Unknown error");
  }
}
}