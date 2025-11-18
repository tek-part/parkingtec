import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request.g.dart';

/// Request model for updating user profile
@JsonSerializable()
class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;

  const UpdateProfileRequest({
    this.name,
    this.phone,
    this.email,
    this.address,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}

