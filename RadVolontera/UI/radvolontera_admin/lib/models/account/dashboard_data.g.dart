// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    DashboardModel(
      json['studentCount'] as int?,
      json['adminCount'] as int?,
      json['mentorCount'] as int?,
    );

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'studentCount': instance.studentCount,
      'mentorCount': instance.mentorCount,
      'adminCount': instance.adminCount,
    };
