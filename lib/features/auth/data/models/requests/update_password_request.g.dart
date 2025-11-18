// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePasswordRequest _$UpdatePasswordRequestFromJson(
  Map<String, dynamic> json,
) => UpdatePasswordRequest(
  oldPassword: json['old_password'] as String,
  password: json['password'] as String,
  passwordConfirmation: json['password_confirmation'] as String,
);

Map<String, dynamic> _$UpdatePasswordRequestToJson(
  UpdatePasswordRequest instance,
) => <String, dynamic>{
  'old_password': instance.oldPassword,
  'password': instance.password,
  'password_confirmation': instance.passwordConfirmation,
};
