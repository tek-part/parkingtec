// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_invoice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayInvoiceRequest _$PayInvoiceRequestFromJson(Map<String, dynamic> json) =>
    PayInvoiceRequest(
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$PayInvoiceRequestToJson(PayInvoiceRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
    };
