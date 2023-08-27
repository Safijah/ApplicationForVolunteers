

import 'package:json_annotation/json_annotation.dart';

part 'exception_result.g.dart';

@JsonSerializable()
class ExceptionResultModel {
int statusCode;
String ? message;

ExceptionResultModel(this.statusCode, this.message);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory ExceptionResultModel.fromJson(Map<String, dynamic> json) => _$ExceptionResultModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ExceptionResultModelToJson(this);
}
