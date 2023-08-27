// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      json['id'] as int?,
      json['notes'] as String?,
      (json['amount'] as num).toDouble(),
      json['month'] as int?,
      json['year'] as int?,
      json['studentId'] as String?,
      json['student'] == null
          ? null
          : AccountModel.fromJson(json['student'] as Map<String, dynamic>),
      json['monthName'] as String?,
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notes': instance.notes,
      'amount': instance.amount,
      'month': instance.month,
      'monthName': instance.monthName,
      'year': instance.year,
      'studentId': instance.studentId,
      'student': instance.student,
    };
