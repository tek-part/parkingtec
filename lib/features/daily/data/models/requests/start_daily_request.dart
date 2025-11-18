import 'package:json_annotation/json_annotation.dart';

part 'start_daily_request.g.dart';

/// Start daily request model
@JsonSerializable()
class StartDailyRequest {
  @JsonKey(name: 'start_balance')
  final double? startBalance;
  final String? notes;

  const StartDailyRequest({this.startBalance, this.notes});

  factory StartDailyRequest.fromJson(Map<String, dynamic> json) =>
      _$StartDailyRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StartDailyRequestToJson(this);
}

