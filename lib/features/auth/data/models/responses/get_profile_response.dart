import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';

part 'get_profile_response.g.dart';

/// Get Profile response model
/// Handles the profile API response structure:
/// {
///   "data": { ... user data ... },
///   "message": "..."
/// }
@JsonSerializable()
class GetProfileResponse {
  @JsonKey(name: 'data')
  final User? user;
  
  @JsonKey(defaultValue: '')
  final String? message;

  const GetProfileResponse({
    this.user,
    this.message,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$GetProfileResponseToJson(this);
}

