// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_invoice_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayInvoiceResponse _$PayInvoiceResponseFromJson(Map<String, dynamic> json) =>
    PayInvoiceResponse(
      data: json['data'] == null
          ? null
          : PayInvoiceData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PayInvoiceResponseToJson(PayInvoiceResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
    };

PayInvoiceData _$PayInvoiceDataFromJson(Map<String, dynamic> json) =>
    PayInvoiceData(
      invoice: json['invoice'] == null
          ? null
          : Invoice.fromJson(json['invoice'] as Map<String, dynamic>),
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$PayInvoiceDataToJson(PayInvoiceData instance) =>
    <String, dynamic>{
      'invoice': instance.invoice,
      'paid_amount': instance.paidAmount,
      'status': instance.status,
    };
