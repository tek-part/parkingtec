// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveDaily _$ActiveDailyFromJson(Map<String, dynamic> json) => ActiveDaily(
      id: (json['id'] as num?)?.toInt() ?? 0,
      wardenId: (json['warden_id'] as num?)?.toInt(),
      startDate: json['start_date'] as String?,
      startBalance: json['start_balance'] as String?,
      endDate: json['end_date'] as String?,
      endBalance: json['end_balance'] as String?,
      balance: json['balance'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ActiveDailyToJson(ActiveDaily instance) =>
    <String, dynamic>{
      'id': instance.id,
      'warden_id': instance.wardenId,
      'start_date': instance.startDate,
      'start_balance': instance.startBalance,
      'end_date': instance.endDate,
      'end_balance': instance.endBalance,
      'balance': instance.balance,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
