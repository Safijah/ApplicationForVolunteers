
import 'package:json_annotation/json_annotation.dart';
import '../section/section.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationModel {
  int? id;
  String? heading;
  String content;
  int? sectionId;
  String? adminId;
  SectionModel? section;

NotificationModel(this.id, this.heading, this.sectionId, this.adminId,this.section, this.content);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
