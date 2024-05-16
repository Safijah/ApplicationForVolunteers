import 'package:json_annotation/json_annotation.dart';
part 'section.g.dart';
@JsonSerializable()
class SectionModel {
  int? id;
  String? name;

SectionModel(this.id, this.name);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
   factory SectionModel.fromJson(Map<String, dynamic> json) => _$SectionModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
   Map<String, dynamic> toJson() => _$SectionModelToJson(this);
}
