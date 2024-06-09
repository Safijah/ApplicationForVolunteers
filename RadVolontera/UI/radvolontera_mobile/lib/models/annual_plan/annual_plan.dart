

import 'package:json_annotation/json_annotation.dart';
import 'package:radvolontera_mobile/models/account/account.dart';
import 'package:radvolontera_mobile/models/annual_template_plan/annual_plan_template.dart';
import 'package:radvolontera_mobile/models/monthly_plan/monthly_plan.dart';
import 'package:radvolontera_mobile/models/status/status.dart';

part 'annual_plan.g.dart';

@JsonSerializable()
class AnnualPlanModel {
  int? id;
  int year;
  List<MonthlyPlanModel> monthlyPlans;
  String? mentorId;
  AccountModel? mentor;
  int? statusId;
  StatusModel? status;
  int? annualPlanTemplateId;
  AnnualPlanTemplateModel? annualPlanTemplate;
  String? reason;
AnnualPlanModel(this.id, this.year,this.monthlyPlans,this.mentorId,this.mentor,this.status,this.statusId,this.annualPlanTemplate,this.annualPlanTemplateId,this.reason);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AnnualPlanModel.fromJson(Map<String, dynamic> json) => _$AnnualPlanModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AnnualPlanModelToJson(this);
}