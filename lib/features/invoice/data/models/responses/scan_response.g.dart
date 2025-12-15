// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResponse _$ScanResponseFromJson(Map<String, dynamic> json) => ScanResponse(
      message: json['message'] as String,
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$ScanResponseToJson(ScanResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
    };
