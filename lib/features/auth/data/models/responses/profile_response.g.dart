// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String,
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'message': instance.message,
      'success': instance.success,
    };
