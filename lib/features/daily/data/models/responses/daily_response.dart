import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';

part 'daily_response.g.dart';

/// Daily response model
@JsonSerializable()
class DailyResponse {
  final Daily daily;
  final String message;
  final bool success;

  const DailyResponse({
    required this.daily,
    required this.message,
    this.success = true,
  });

  factory DailyResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DailyResponseToJson(this);
}
