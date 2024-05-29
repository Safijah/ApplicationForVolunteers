

import 'package:json_annotation/json_annotation.dart';

part 'monitoring.g.dart';
@JsonSerializable()
class MonitoringModel {
  int? id;
  String notes;
  String url;
  String mentorId;
  DateTime ? date;

MonitoringModel(this.id, this.notes,this.url,this.mentorId,this.date);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
   factory MonitoringModel.fromJson(Map<String, dynamic> json) => _$MonitoringModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
   Map<String, dynamic> toJson() => _$MonitoringModelToJson(this);
}