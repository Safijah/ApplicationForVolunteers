import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_admin/models/monthly_plan_template/monthly_plan_template.dart';

part 'annual_plan_template.g.dart';

@JsonSerializable()
class AnnualPlanTemplateModel {
  int? id;
  int year;
  List<MonthlyPlanTemplateModel> monthlyPlanTemplates;
AnnualPlanTemplateModel(this.id, this.year,this.monthlyPlanTemplates);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AnnualPlanTemplateModel.fromJson(Map<String, dynamic> json) => _$AnnualPlanTemplateModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AnnualPlanTemplateModelToJson(this);
}