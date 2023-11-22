// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentReportModel _$PaymentReportModelFromJson(Map<String, dynamic> json) =>
    PaymentReportModel(
      json['monthName'] as String?,
      (json['amount'] as num?)?.toDouble(),
      json['month'] as int?,
    );

Map<String, dynamic> _$PaymentReportModelToJson(PaymentReportModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'monthName': instance.monthName,
      'month': instance.month,
    };
