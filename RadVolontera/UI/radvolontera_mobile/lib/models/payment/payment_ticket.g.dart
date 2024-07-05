// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentTicketModel _$PaymentTicketModelFromJson(Map<String, dynamic> json) =>
    PaymentTicketModel(
      json['cardNumber'] as String?,
      json['month'] as String?,
      json['year'] as String?,
      json['cvc'] as String?,
      (json['totalPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentTicketModelToJson(PaymentTicketModel instance) =>
    <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'month': instance.month,
      'year': instance.year,
      'cvc': instance.cvc,
      'totalPrice': instance.totalPrice,
    };
