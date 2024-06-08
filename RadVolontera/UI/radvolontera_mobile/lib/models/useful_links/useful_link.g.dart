// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'useful_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsefulLinkModel _$UsefulLinkModelFromJson(Map<String, dynamic> json) =>
    UsefulLinkModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['urlLink'] as String?,
      json['adminId'] as String?,
    );

Map<String, dynamic> _$UsefulLinkModelToJson(UsefulLinkModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'urlLink': instance.urlLink,
      'adminId': instance.adminId,
    };
