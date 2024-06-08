// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_plan_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyPlanTemplateModel _$MonthlyPlanTemplateModelFromJson(
        Map<String, dynamic> json) =>
    MonthlyPlanTemplateModel(
      (json['id'] as num?)?.toInt(),
      json['theme'] as String?,
      (json['month'] as num?)?.toInt(),
      json['monthName'] as String?,
    );

Map<String, dynamic> _$MonthlyPlanTemplateModelToJson(
        MonthlyPlanTemplateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theme': instance.theme,
      'month': instance.month,
      'monthName': instance.monthName,
    };
