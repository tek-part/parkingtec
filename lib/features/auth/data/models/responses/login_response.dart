import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';

part 'login_response.g.dart';

/// Login response model
/// Handles the login API response structure:
/// {
///   "token": "...",
///   "data": { ... user data ... },
///   "message": "..."
/// }
@JsonSerializable()
class LoginResponse {
  final String? token;
  @JsonKey(name: 'data')
  final User? user;
  final String? message;

  const LoginResponse({this.token, this.user, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
