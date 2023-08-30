

import 'package:json_annotation/json_annotation.dart';

part 'dashboard_data.g.dart';

@JsonSerializable()
class DashboardModel {
  int? studentCount ;
   int? mentorCount ;
    int? adminCount ;
DashboardModel(this.studentCount,this.adminCount,this.mentorCount);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory DashboardModel.fromJson(Map<String, dynamic> json) => _$DashboardModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);
}