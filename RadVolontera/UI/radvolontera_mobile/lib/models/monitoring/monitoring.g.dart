// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitoringModel _$MonitoringModelFromJson(Map<String, dynamic> json) =>
    MonitoringModel(
      json['id'] as int?,
      json['notes'] as String,
      json['url'] as String,
      json['mentorId'] as String,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$MonitoringModelToJson(MonitoringModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'url': instance.url,
      'mentorId': instance.mentorId,
      'date': instance.date?.toIso8601String(),
    };
