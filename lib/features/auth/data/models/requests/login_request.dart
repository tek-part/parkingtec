import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// Login request model
@JsonSerializable()
class LoginRequest {
  final String phone;
  final String password;
  @JsonKey(name: 'device_token')
  String? deviceToken;

  LoginRequest({
    required this.phone,
    required this.password,
    this.deviceToken,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

