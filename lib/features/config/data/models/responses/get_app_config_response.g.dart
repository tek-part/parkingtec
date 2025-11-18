// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_app_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAppConfigResponse _$GetAppConfigResponseFromJson(
  Map<String, dynamic> json,
) => GetAppConfigResponse(
  config: json['data'] == null
      ? null
      : AppConfig.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String? ?? '',
);

Map<String, dynamic> _$GetAppConfigResponseToJson(
  GetAppConfigResponse instance,
) => <String, dynamic>{'data': instance.config, 'message': instance.message};
