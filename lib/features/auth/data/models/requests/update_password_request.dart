import 'package:json_annotation/json_annotation.dart';

part 'update_password_request.g.dart';

/// Request model for updating user password
@JsonSerializable()
class UpdatePasswordRequest {
  @JsonKey(name: 'old_password')
  final String oldPassword;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  const UpdatePasswordRequest({
    required this.oldPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  factory UpdatePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordRequestToJson(this);
}

