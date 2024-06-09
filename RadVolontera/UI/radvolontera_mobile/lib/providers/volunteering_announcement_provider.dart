import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:radvolontera_mobile/models/search_result.dart';
import '../models/volunteering_announcement/volunteering_announcement.dart';
import 'base_provider.dart';

class VolunteeringAnnouncementProvider
    extends BaseProvider<VolunteeringAnnouncementModel> {
  VolunteeringAnnouncementProvider() : super("VolunteeringAnnouncement");

  IOClient? http; // Use the IOClient for making HTTP requests

  @override
  VolunteeringAnnouncementModel fromJson(data) {
    // TODO: implement fromJson
    return VolunteeringAnnouncementModel.fromJson(data);
  }

  Future<SearchResult<VolunteeringAnnouncementModel>> getAnnoucments(
      String mentorId) async {
     var url = "${BaseProvider.baseUrl}VolunteeringAnnouncement/student-announcements/$mentorId";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<VolunteeringAnnouncementModel>();

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  // Initialize the IOClient with the custom HttpClient
  VolunteeringAnnouncementProvider.withHttpClient()
      : super("VolunteeringAnnouncement") {
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }
}
