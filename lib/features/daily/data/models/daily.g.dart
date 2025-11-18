// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
  id: (json['id'] as num?)?.toInt() ?? 0,
  wardenId: (json['warden_id'] as num?)?.toInt() ?? 0,
  userId: (json['user_id'] as num?)?.toInt() ?? 0,
  startDate: json['start_date'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  startBalance: (json['start_balance'] as num?)?.toDouble() ?? 0.0,
  endBalance: (json['end_balance'] as num?)?.toDouble(),
  balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
  notes: json['notes'] as String?,
  status: json['status'] as String? ?? 'active',
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
  'id': instance.id,
  'warden_id': instance.wardenId,
  'user_id': instance.userId,
  'start_date': instance.startDate,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'start_balance': instance.startBalance,
  'end_balance': instance.endBalance,
  'balance': instance.balance,
  'notes': instance.notes,
  'status': instance.status,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
