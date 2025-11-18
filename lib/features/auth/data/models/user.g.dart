// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String?,
  picture: json['picture'] as String?,
  emailVerifiedAt: json['email_verified_at'] as String?,
  status: (json['status'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  pictureUrl: json['picture_url'] as String?,
  todaySalesBalance: json['today_sales_balance'] as String?,
  totalActiveCars: json['total_active_cars'] as String?,
  activeDaily: json['active_daily'] == null
      ? null
      : ActiveDaily.fromJson(json['active_daily'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'picture': instance.picture,
  'email_verified_at': instance.emailVerifiedAt,
  'status': instance.status,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'picture_url': instance.pictureUrl,
  'today_sales_balance': instance.todaySalesBalance,
  'total_active_cars': instance.totalActiveCars,
  'active_daily': instance.activeDaily,
};
