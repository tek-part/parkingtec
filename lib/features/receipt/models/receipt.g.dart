// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => Receipt(
      id: (json['id'] as num).toInt(),
      invoiceId: (json['invoice_id'] as num).toInt(),
      customerName: json['customer_name'] as String,
      carNum: json['car_num'] as String,
      carModel: json['car_model'] as String,
      amount: (json['amount'] as num).toDouble(),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'id': instance.id,
      'invoice_id': instance.invoiceId,
      'customer_name': instance.customerName,
      'car_num': instance.carNum,
      'car_model': instance.carModel,
      'amount': instance.amount,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
