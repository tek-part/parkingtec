import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';

part 'get_app_config_response.g.dart';

/// Get App Config response model
/// Handles the app config API response structure:
/// {
///   "data": { ... config data ... },
///   "message": "..."
/// }
@JsonSerializable()
class GetAppConfigResponse {
  @JsonKey(name: 'data')
  final AppConfig? config;
  
  @JsonKey(defaultValue: '')
  final String? message;

  const GetAppConfigResponse({
    this.config,
    this.message,
  });

  factory GetAppConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAppConfigResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$GetAppConfigResponseToJson(this);
}

