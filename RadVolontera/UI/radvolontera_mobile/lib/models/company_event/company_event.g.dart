// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyEventModel _$CompanyEventModelFromJson(Map<String, dynamic> json) =>
    CompanyEventModel(
      (json['id'] as num?)?.toInt(),
      json['eventName'] as String?,
      json['location'] as String,
      json['time'] as String?,
      json['company'] == null
          ? null
          : CompanyModel.fromJson(json['company'] as Map<String, dynamic>),
      (json['companyId'] as num?)?.toInt(),
      json['eventDate'] == null
          ? null
          : DateTime.parse(json['eventDate'] as String),
      json['registered'] as bool,
      (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$CompanyEventModelToJson(CompanyEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventName': instance.eventName,
      'location': instance.location,
      'time': instance.time,
      'companyId': instance.companyId,
      'company': instance.company,
      'eventDate': instance.eventDate?.toIso8601String(),
      'registered': instance.registered,
      'price': instance.price,
    };
