// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String?,
      startBalance: (json['start_balance'] as num).toDouble(),
      endBalance: (json['end_balance'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'start_balance': instance.startBalance,
      'end_balance': instance.endBalance,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
