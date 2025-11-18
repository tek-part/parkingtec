import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';

part 'profile_response.g.dart';

/// Profile response model
@JsonSerializable()
class ProfileResponse {
  final User user;
  final String message;
  final bool success;

  const ProfileResponse({
    required this.user,
    required this.message,
    this.success = true,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}
