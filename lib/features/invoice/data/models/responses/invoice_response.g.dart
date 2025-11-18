// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceResponse _$InvoiceResponseFromJson(Map<String, dynamic> json) =>
    InvoiceResponse(
      invoice: Invoice.fromJson(json['invoice'] as Map<String, dynamic>),
      message: json['message'] as String,
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$InvoiceResponseToJson(InvoiceResponse instance) =>
    <String, dynamic>{
      'invoice': instance.invoice,
      'message': instance.message,
      'success': instance.success,
    };
