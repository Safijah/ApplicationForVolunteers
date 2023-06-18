import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'notification.g.dart';

@JsonSerializable()
class Notification {
  int? id;
  String? heading;
  int? sectionId;
  String? adminId;

Notification(this.id, this.heading, this.sectionId, this.adminId);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
