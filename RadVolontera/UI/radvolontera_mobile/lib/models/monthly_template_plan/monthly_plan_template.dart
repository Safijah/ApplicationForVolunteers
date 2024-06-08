import 'package:json_annotation/json_annotation.dart';

part 'monthly_plan_template.g.dart';

@JsonSerializable()
class MonthlyPlanTemplateModel {
  int? id;
  String? theme;
  int? month;
  String ? monthName;
MonthlyPlanTemplateModel(this.id, this.theme,this.month,this.monthName);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory MonthlyPlanTemplateModel.fromJson(Map<String, dynamic> json) => _$MonthlyPlanTemplateModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$MonthlyPlanTemplateModelToJson(this);
}