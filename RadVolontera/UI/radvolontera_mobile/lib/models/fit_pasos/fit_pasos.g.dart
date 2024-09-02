// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fit_pasos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FITPasosModel _$FITPasosModelFromJson(Map<String, dynamic> json) =>
    FITPasosModel(
      (json['id'] as num?)?.toInt(),
      json['datumIzdavanja'] == null
          ? null
          : DateTime.parse(json['datumIzdavanja'] as String),
      json['isValid'] as bool,
      json['user'] == null
          ? null
          : AccountModel.fromJson(json['user'] as Map<String, dynamic>),
      json['userId'] as String?,
    );

Map<String, dynamic> _$FITPasosModelToJson(FITPasosModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'datumIzdavanja': instance.datumIzdavanja?.toIso8601String(),
      'isValid': instance.isValid,
      'userId': instance.userId,
      'user': instance.user,
    };
