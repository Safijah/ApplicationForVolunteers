// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annual_plan_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnualPlanTemplateModel _$AnnualPlanTemplateModelFromJson(
        Map<String, dynamic> json) =>
    AnnualPlanTemplateModel(
      (json['id'] as num?)?.toInt(),
      (json['year'] as num).toInt(),
      (json['monthlyPlanTemplates'] as List<dynamic>)
          .map((e) =>
              MonthlyPlanTemplateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnnualPlanTemplateModelToJson(
        AnnualPlanTemplateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'monthlyPlanTemplates': instance.monthlyPlanTemplates,
    };
