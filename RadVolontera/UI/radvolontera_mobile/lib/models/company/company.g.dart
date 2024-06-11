// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['address'] as String?,
      json['phoneNumber'] as String?,
      json['email'] as String?,
      (json['cityId'] as num?)?.toInt(),
      json['city'] == null
          ? null
          : CityModel.fromJson(json['city'] as Map<String, dynamic>),
      json['companyCategory'] == null
          ? null
          : CompanyCategoryModel.fromJson(
              json['companyCategory'] as Map<String, dynamic>),
      (json['companyCategoryId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'cityId': instance.cityId,
      'city': instance.city,
      'companyCategoryId': instance.companyCategoryId,
      'companyCategory': instance.companyCategory,
    };
