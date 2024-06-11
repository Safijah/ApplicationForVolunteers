// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyCategoryModel _$CompanyCategoryModelFromJson(
        Map<String, dynamic> json) =>
    CompanyCategoryModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
    );

Map<String, dynamic> _$CompanyCategoryModelToJson(
        CompanyCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
