


import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_admin/models/account/account.dart';
import 'package:radvolontera_admin/models/city/city.dart';
import 'package:radvolontera_admin/models/status/status.dart';

part 'volunteering_announcement.g.dart';
@JsonSerializable()
class VolunteeringAnnouncementModel {
  int? id;
  String? place;
 int? announcementStatusId;
  StatusModel? announcementStatus;
  int? cityId;
  CityModel? city;
  String? mentorId;
  AccountModel? mentor;
  String timeFrom;
  String timeTo;
 String? notes;
 DateTime ? date;
 String ? reason;
VolunteeringAnnouncementModel(this.id, this.place, this.announcementStatusId, 
this.announcementStatus,this.cityId,this.city,this.mentorId,this.mentor,this.timeFrom,this.timeTo,this.reason);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
   factory VolunteeringAnnouncementModel.fromJson(Map<String, dynamic> json) => _$VolunteeringAnnouncementModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
   Map<String, dynamic> toJson() => _$VolunteeringAnnouncementModelToJson(this);
}