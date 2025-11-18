// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminate_daily_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TerminateDailyRequest _$TerminateDailyRequestFromJson(
  Map<String, dynamic> json,
) => TerminateDailyRequest(
  endBalance: (json['end_balance'] as num).toDouble(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$TerminateDailyRequestToJson(
  TerminateDailyRequest instance,
) => <String, dynamic>{
  'end_balance': instance.endBalance,
  'notes': instance.notes,
};
