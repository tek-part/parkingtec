// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_daily_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartDailyRequest _$StartDailyRequestFromJson(Map<String, dynamic> json) =>
    StartDailyRequest(
      startBalance: (json['start_balance'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$StartDailyRequestToJson(StartDailyRequest instance) =>
    <String, dynamic>{
      'start_balance': instance.startBalance,
      'notes': instance.notes,
    };
