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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
