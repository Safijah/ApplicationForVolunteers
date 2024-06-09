// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annual_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnualPlanModel _$AnnualPlanModelFromJson(Map<String, dynamic> json) =>
    AnnualPlanModel(
      json['id'] as int?,
      json['year'] as int,
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
      json['statusId'] as int?,
      json['annualPlanTemplate'] == null
          ? null
          : AnnualPlanTemplateModel.fromJson(
              json['annualPlanTemplate'] as Map<String, dynamic>),
      json['annualPlanTemplateId'] as int?,
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
