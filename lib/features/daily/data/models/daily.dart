import 'package:json_annotation/json_annotation.dart';

part 'daily.g.dart';

/// Daily shift model
/// Supports both old API format (user_id, start_time) and new format (warden_id, start_date)
@JsonSerializable()
class Daily {
  @JsonKey(defaultValue: 0)
  final int? id;

  @JsonKey(name: 'warden_id', defaultValue: 0)
  final int? wardenId;

  @JsonKey(name: 'user_id', defaultValue: 0)
  final int? userId;

  @JsonKey(name: 'start_date')
  final String? startDate;

  @JsonKey(name: 'start_time')
  final String? startTime;

  @JsonKey(name: 'end_time')
  final String? endTime;

  @JsonKey(name: 'start_balance', defaultValue: 0.0)
  final double? startBalance;

  @JsonKey(name: 'end_balance')
  final double? endBalance;

  @JsonKey(defaultValue: 0.0)
  final double? balance;

  final String? notes;

  @JsonKey(defaultValue: 'active')
  final String? status;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const Daily({
    this.id = 0,
    this.wardenId,
    this.userId,
    this.startDate,
    this.startTime,
    this.endTime,
    this.startBalance = 0.0,
    this.endBalance,
    this.balance = 0.0,
    this.notes,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    // Handle both warden_id and user_id
    final wardenId = json['warden_id'] as int?;
    final userId = json['user_id'] as int?;

    // Handle both start_date and start_time
    final startDate = json['start_date'] as String?;
    final startTime = json['start_time'] as String?;

    return Daily(
      id: (json['id'] as num?)?.toInt() ?? 0,
      wardenId: wardenId,
      userId: userId ?? wardenId, // Use wardenId as fallback for userId
      startDate: startDate,
      startTime:
          startTime ?? startDate, // Use startDate as fallback for startTime
      endTime: json['end_time'] as String?,
      startBalance: (json['start_balance'] as num?)?.toDouble() ?? 0.0,
      endBalance: (json['end_balance'] as num?)?.toDouble(),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$DailyToJson(this);

  /// Get the effective user ID (wardenId or userId)
  int get effectiveUserId => wardenId ?? userId ?? 0;

  /// Get the effective start time (startDate or startTime)
  String? get effectiveStartTime => startDate ?? startTime;

  /// Calculate daily duration
  Duration get duration {
    final startStr = effectiveStartTime;
    if (startStr == null) return Duration.zero;

    try {
      final start = DateTime.parse(startStr);
      final end = endTime != null ? DateTime.parse(endTime!) : DateTime.now();
      return end.difference(start);
    } catch (e) {
      return Duration.zero;
    }
  }

  /// Check if daily is active
  bool get isActive {
    final currentStatus = status ?? 'active';
    return currentStatus == 'active' && endTime == null;
  }
}
