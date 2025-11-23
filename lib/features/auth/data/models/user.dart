import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/auth/data/models/active_daily.dart';

part 'user.g.dart';

/// User model for authentication
@JsonSerializable()
class User {
  @JsonKey(defaultValue: 0)
  final int id;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? picture;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  final int? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'picture_url')
  final String? pictureUrl;
  @JsonKey(name: 'today_sales_balance')
  final String? todaySalesBalance;
  @JsonKey(name: 'total_active_cars')
  final String? totalActiveCars;
  @JsonKey(name: 'active_daily')
  final ActiveDaily? activeDaily;

  const User({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.picture,
    this.emailVerifiedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.pictureUrl,
    this.todaySalesBalance,
    this.totalActiveCars,
    this.activeDaily,
  });

  /// Check if user has an active daily shift
  bool get hasActiveDaily => activeDaily != null && activeDaily!.isActive;

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      // Handle active_daily safely - it might not be a Map
      final activeDailyValue = json['active_daily'];
      final jsonCopy = Map<String, dynamic>.from(json);
      
      // If active_daily is not null and not a Map, set it to null
      if (activeDailyValue != null && activeDailyValue is! Map<String, dynamic>) {
        debugPrint('Warning: active_daily is not a Map, type: ${activeDailyValue.runtimeType}, value: $activeDailyValue');
        jsonCopy['active_daily'] = null;
      }
      
      return _$UserFromJson(jsonCopy);
    } catch (e, stackTrace) {
      // Log the error for debugging
      debugPrint('=== USER JSON PARSING ERROR ===');
      debugPrint('Error: $e');
      debugPrint('JSON: $json');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('==============================');
      
      // Try to parse without active_daily if it's causing issues
      try {
        final jsonWithoutActiveDaily = Map<String, dynamic>.from(json);
        jsonWithoutActiveDaily.remove('active_daily');
        debugPrint('Retrying without active_daily...');
        return _$UserFromJson(jsonWithoutActiveDaily);
      } catch (e2) {
        // If that also fails, rethrow the original error
        rethrow;
      }
    }
  }
  
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
