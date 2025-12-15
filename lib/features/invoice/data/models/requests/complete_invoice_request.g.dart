// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_invoice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteInvoiceRequest _$CompleteInvoiceRequestFromJson(
        Map<String, dynamic> json) =>
    CompleteInvoiceRequest(
      invoiceId: (json['invoice_id'] as num).toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CompleteInvoiceRequestToJson(
        CompleteInvoiceRequest instance) =>
    <String, dynamic>{
      'invoice_id': instance.invoiceId,
      'amount': instance.amount,
    };
