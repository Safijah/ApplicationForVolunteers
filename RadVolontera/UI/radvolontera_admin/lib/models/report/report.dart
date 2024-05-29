





import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/city/city.dart';
import 'package:radvolontera_admin/models/status/status.dart';
import 'package:radvolontera_admin/models/volunteering_announcement/volunteering_announcement.dart';

import '../volunteering_announcement/volunteering_announcement.dart';

part 'report.g.dart';
@JsonSerializable()
class ReportModel {
  int? id;
  String? notes;
  String? goal;
  String? volunteerActivities;
  String? themes;
  int? statusId;
  StatusModel? status;
  int? volunteeringAnnouncementId;
  VolunteeringAnnouncementModel? volunteeringAnnouncement;
  AccountModel? mentor;
  List<AccountModel>? absentStudents; 
  List<AccountModel>? presentStudents; 
  String ? reason;
ReportModel(this.id, this.notes, this.volunteerActivities, 
this.themes,this.status,this.statusId,this.volunteeringAnnouncement,this.volunteeringAnnouncementId,this.mentor,
this.absentStudents, this.presentStudents,this.reason);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
   factory ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
   Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}