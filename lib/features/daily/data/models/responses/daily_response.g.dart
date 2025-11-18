// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyResponse _$DailyResponseFromJson(Map<String, dynamic> json) =>
    DailyResponse(
      daily: Daily.fromJson(json['daily'] as Map<String, dynamic>),
      message: json['message'] as String,
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$DailyResponseToJson(DailyResponse instance) =>
    <String, dynamic>{
      'daily': instance.daily,
      'message': instance.message,
      'success': instance.success,
    };
