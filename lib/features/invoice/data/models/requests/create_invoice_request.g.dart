// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_invoice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInvoiceRequest _$CreateInvoiceRequestFromJson(
  Map<String, dynamic> json,
) => CreateInvoiceRequest(
  customerName: json['customer_name'] as String?,
  carNum: json['car_num'] as String,
  carModel: json['car_model'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CreateInvoiceRequestToJson(
  CreateInvoiceRequest instance,
) => <String, dynamic>{
  'customer_name': instance.customerName,
  'car_num': instance.carNum,
  'car_model': instance.carModel,
  'amount': instance.amount,
};
