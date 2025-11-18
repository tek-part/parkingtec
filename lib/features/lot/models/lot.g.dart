// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lot _$LotFromJson(Map<String, dynamic> json) => Lot(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  location: json['location'] as String,
  capacity: (json['capacity'] as num).toInt(),
  occupied: (json['occupied'] as num).toInt(),
  isActive: json['isActive'] as bool,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$LotToJson(Lot instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'capacity': instance.capacity,
  'occupied': instance.occupied,
  'isActive': instance.isActive,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
