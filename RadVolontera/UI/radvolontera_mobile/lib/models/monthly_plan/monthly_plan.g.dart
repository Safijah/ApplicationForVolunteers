// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyPlanModel _$MonthlyPlanModelFromJson(Map<String, dynamic> json) =>
    MonthlyPlanModel(
      (json['id'] as num?)?.toInt(),
      json['theme1'] as String?,
      json['theme2'] as String?,
      json['goals1'] as String?,
      json['goals2'] as String?,
      (json['month'] as num?)?.toInt(),
      json['monthName'] as String?,
    );

Map<String, dynamic> _$MonthlyPlanModelToJson(MonthlyPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theme1': instance.theme1,
      'theme2': instance.theme2,
      'goals1': instance.goals1,
      'goals2': instance.goals2,
      'month': instance.month,
      'monthName': instance.monthName,
    };
