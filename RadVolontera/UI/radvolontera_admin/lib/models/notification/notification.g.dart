// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      json['id'] as int?,
      json['heading'] as String?,
      json['sectionId'] as int?,
      json['adminId'] as String?,
      json['section'] == null
          ? null
          : SectionModel.fromJson(json['section'] as Map<String, dynamic>),
      json['content'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heading': instance.heading,
      'content': instance.content,
      'sectionId': instance.sectionId,
      'adminId': instance.adminId,
      'section': instance.section,
    };
