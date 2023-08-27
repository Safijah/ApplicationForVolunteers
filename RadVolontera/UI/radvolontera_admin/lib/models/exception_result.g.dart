// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionResultModel _$ExceptionResultModelFromJson(
        Map<String, dynamic> json) =>
    ExceptionResultModel(
      json['statusCode'] as int,
      json['message'] as String?,
    );

Map<String, dynamic> _$ExceptionResultModelToJson(
        ExceptionResultModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
    };
