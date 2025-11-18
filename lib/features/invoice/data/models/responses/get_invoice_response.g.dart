// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_invoice_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInvoiceResponse _$GetInvoiceResponseFromJson(Map<String, dynamic> json) =>
    GetInvoiceResponse(
      invoice: json['data'] == null
          ? null
          : Invoice.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$GetInvoiceResponseToJson(GetInvoiceResponse instance) =>
    <String, dynamic>{'data': instance.invoice, 'message': instance.message};
