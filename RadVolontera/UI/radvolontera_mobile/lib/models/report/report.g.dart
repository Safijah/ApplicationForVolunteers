// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      json['id'] as int?,
      json['notes'] as String?,
      json['volunteerActivities'] as String?,
      json['themes'] as String?,
      json['status'] == null
          ? null
          : StatusModel.fromJson(json['status'] as Map<String, dynamic>),
      json['statusId'] as int?,
      json['volunteeringAnnouncement'] == null
          ? null
          : VolunteeringAnnouncementModel.fromJson(
              json['volunteeringAnnouncement'] as Map<String, dynamic>),
      json['volunteeringAnnouncementId'] as int?,
      json['mentor'] == null
          ? null
          : AccountModel.fromJson(json['mentor'] as Map<String, dynamic>),
      (json['absentStudents'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['presentStudents'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['reason'] as String?,
    )..goal = json['goal'] as String?;

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'goal': instance.goal,
      'volunteerActivities': instance.volunteerActivities,
      'themes': instance.themes,
      'statusId': instance.statusId,
      'status': instance.status,
      'volunteeringAnnouncementId': instance.volunteeringAnnouncementId,
      'volunteeringAnnouncement': instance.volunteeringAnnouncement,
      'mentor': instance.mentor,
      'absentStudents': instance.absentStudents,
      'presentStudents': instance.presentStudents,
      'reason': instance.reason,
    };
