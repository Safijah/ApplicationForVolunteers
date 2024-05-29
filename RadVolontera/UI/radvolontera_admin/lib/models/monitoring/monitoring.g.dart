// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitoringModel _$MonitoringModelFromJson(Map<String, dynamic> json) =>
    MonitoringModel(
      json['id'] as int?,
      json['notes'] as String,
      json['mentor'] == null
          ? null
          : AccountModel.fromJson(json['mentor'] as Map<String, dynamic>),
      json['mentorId'] as String,
      json['url'] as String,
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$MonitoringModelToJson(MonitoringModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'mentorId': instance.mentorId,
      'url': instance.url,
      'mentor': instance.mentor,
      'date': instance.date.toIso8601String(),
    };
