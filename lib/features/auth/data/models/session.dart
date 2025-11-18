import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

/// Session model for daily shifts
@JsonSerializable()
class Session {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String? endTime;
  @JsonKey(name: 'start_balance')
  final double startBalance;
  @JsonKey(name: 'end_balance')
  final double? endBalance;
  final String? notes;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Session({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.startBalance,
    this.endBalance,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  /// Calculate session duration
  Duration get duration {
    final start = DateTime.parse(startTime);
    final end = endTime != null ? DateTime.parse(endTime!) : DateTime.now();
    return end.difference(start);
  }

  /// Check if session is active
  bool get isActive => status == 'active' && endTime == null;
}

