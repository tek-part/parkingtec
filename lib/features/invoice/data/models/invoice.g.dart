// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
  invoiceId: (json['invoice_id'] as num?)?.toInt() ?? 0,
  customerName: json['customer_name'] as String?,
  carNum: json['car_num'] as String,
  carModel: json['car_model'] as String?,
  pricingType: json['pricing_type'] as String? ?? 'fixed',
  amount: _parseDouble(json['amount']),
  finalAmount: _parseDouble(json['final_amount']),
  hourlyRate: _parseDouble(json['hourly_rate']),
  hours: (json['hours'] as num?)?.toDouble() ?? 0.0,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String?,
  startTimestamp: (json['start_timestamp'] as num?)?.toInt(),
  endTimestamp: (json['end_timestamp'] as num?)?.toInt(),
  durationHours: (json['duration_hours'] as num?)?.toDouble() ?? 0.0,
  hasQrCode: json['has_qr_code'] as bool? ?? false,
  qrCode: json['qr_code'] as String?,
  status: json['status'] as String? ?? 'active',
  carStatus: json['car_status'] as String? ?? 'active',
  statusLabel: json['status_label'] as String?,
  requested: json['requested'] as bool? ?? false,
  wardenName: json['warden_name'] as String?,
  dailyDate: json['daily_date'] as String?,
  documentUrl: json['document_url'] as String?,
);

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
  'invoice_id': instance.invoiceId,
  'customer_name': instance.customerName,
  'car_num': instance.carNum,
  'car_model': instance.carModel,
  'pricing_type': instance.pricingType,
  'amount': instance.amount,
  'final_amount': instance.finalAmount,
  'hourly_rate': instance.hourlyRate,
  'hours': instance.hours,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'start_timestamp': instance.startTimestamp,
  'end_timestamp': instance.endTimestamp,
  'duration_hours': instance.durationHours,
  'has_qr_code': instance.hasQrCode,
  'qr_code': instance.qrCode,
  'status': instance.status,
  'car_status': instance.carStatus,
  'status_label': instance.statusLabel,
  'requested': instance.requested,
  'warden_name': instance.wardenName,
  'daily_date': instance.dailyDate,
  'document_url': instance.documentUrl,
};
