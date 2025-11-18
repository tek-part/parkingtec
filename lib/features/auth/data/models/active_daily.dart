import 'package:json_annotation/json_annotation.dart';

part 'active_daily.g.dart';

/// Active Daily model
/// Represents an active daily shift in the login response
@JsonSerializable()
class ActiveDaily {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(name: 'warden_id')
  final int? wardenId;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'start_balance')
  final String? startBalance;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'end_balance')
  final String? endBalance;
  final String? balance;
  final String? notes;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const ActiveDaily({
    required this.id,
    this.wardenId,
    this.startDate,
    this.startBalance,
    this.endDate,
    this.endBalance,
    this.balance,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory ActiveDaily.fromJson(Map<String, dynamic> json) =>
      _$ActiveDailyFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveDailyToJson(this);

  /// Check if daily is active (no end date)
  bool get isActive => endDate == null;
}
