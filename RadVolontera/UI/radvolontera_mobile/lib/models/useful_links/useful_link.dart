

import 'package:json_annotation/json_annotation.dart';

part 'useful_link.g.dart';
@JsonSerializable()
class UsefulLinkModel {
  int? id;
  String? name;
  String? urlLink;
  String? adminId;

UsefulLinkModel(this.id, this.name, this.urlLink, this.adminId);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
   factory UsefulLinkModel.fromJson(Map<String, dynamic> json) => _$UsefulLinkModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
   Map<String, dynamic> toJson() => _$UsefulLinkModelToJson(this);
}