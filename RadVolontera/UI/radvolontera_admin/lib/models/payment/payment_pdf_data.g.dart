// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_pdf_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentPdfDataModel _$PaymentPdfDataModelFromJson(Map<String, dynamic> json) =>
    PaymentPdfDataModel(
      json['student'] == null
          ? null
          : AccountModel.fromJson(json['student'] as Map<String, dynamic>),
      (json['payments'] as List<dynamic>)
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentPdfDataModelToJson(
        PaymentPdfDataModel instance) =>
    <String, dynamic>{
      'payments': instance.payments,
      'student': instance.student,
    };
