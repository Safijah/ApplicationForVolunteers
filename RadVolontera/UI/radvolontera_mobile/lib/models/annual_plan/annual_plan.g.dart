// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annual_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnualPlanModel _$AnnualPlanModelFromJson(Map<String, dynamic> json) =>
    AnnualPlanModel(
      (json['id'] as num?)?.toInt(),
      (json['year'] as num).toInt(),
      (json['monthlyPlans'] as List<dynamic>)
          .map((e) => MonthlyPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['mentorId'] as String?,
      json['mentor'] == null
          ? null
          : AccountModel.fromJson(json['mentor'] as Map<String, dynamic>),
      json['status'] == null
          ? null
          : StatusModel.fromJson(json['status'] as Map<String, dynamic>),
      (json['statusId'] as num?)?.toInt(),
      json['annualPlanTemplate'] == null
          ? null
          : AnnualPlanTemplateModel.fromJson(
              json['annualPlanTemplate'] as Map<String, dynamic>),
      (json['annualPlanTemplateId'] as num?)?.toInt(),
      json['reason'] as String?,
    );

Map<String, dynamic> _$AnnualPlanModelToJson(AnnualPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'year': instance.year,
      'monthlyPlans': instance.monthlyPlans,
      'mentorId': instance.mentorId,
      'mentor': instance.mentor,
      'statusId': instance.statusId,
      'status': instance.status,
      'annualPlanTemplateId': instance.annualPlanTemplateId,
      'annualPlanTemplate': instance.annualPlanTemplate,
      'reason': instance.reason,
    };
