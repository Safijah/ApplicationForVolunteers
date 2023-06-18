// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      json['id'] as int?,
      json['heading'] as String?,
      json['sectionId'] as int?,
      json['adminId'] as String?,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heading': instance.heading,
      'sectionId': instance.sectionId,
      'adminId': instance.adminId,
    };
