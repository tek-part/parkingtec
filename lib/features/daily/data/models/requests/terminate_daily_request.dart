import 'package:json_annotation/json_annotation.dart';

part 'terminate_daily_request.g.dart';

/// Terminate daily request model
@JsonSerializable()
class TerminateDailyRequest {
  @JsonKey(name: 'end_balance')
  final double endBalance;
  final String? notes;

  const TerminateDailyRequest({required this.endBalance, this.notes});

  factory TerminateDailyRequest.fromJson(Map<String, dynamic> json) =>
      _$TerminateDailyRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TerminateDailyRequestToJson(this);
}

