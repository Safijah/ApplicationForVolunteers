import 'package:json_annotation/json_annotation.dart';

part 'monthly_plan.g.dart';

@JsonSerializable()
class MonthlyPlanModel {
  int? id;
  String? theme1;
  String? theme2;
  String? goals1;
  String? goals2;
  int? month;
  String ? monthName;
MonthlyPlanModel(this.id, this.theme1,this.theme2,this.goals1,this.goals2,this.month,this.monthName);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory MonthlyPlanModel.fromJson(Map<String, dynamic> json) => _$MonthlyPlanModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$MonthlyPlanModelToJson(this);
}