import 'package:json_annotation/json_annotation.dart';

part 'company_category.g.dart';

@JsonSerializable()
class CompanyCategoryModel {
  int? id;
  String? name;

CompanyCategoryModel(this.id, this.name);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CompanyCategoryModel.fromJson(Map<String, dynamic> json) => _$CompanyCategoryModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CompanyCategoryModelToJson(this);
}
