// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: (json['id'] as num).toInt(),
      customerName: json['customer_name'] as String,
      carNum: json['car_num'] as String,
      carModel: json['car_model'] as String,
      carColor: json['car_color'] as String,
      status: json['status'] as String,
      lotId: (json['lot_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'customer_name': instance.customerName,
      'car_num': instance.carNum,
      'car_model': instance.carModel,
      'car_color': instance.carColor,
      'status': instance.status,
      'lot_id': instance.lotId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
