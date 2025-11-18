import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

/// Vehicle model for parking vehicles
@JsonSerializable()
class Vehicle {
  final int id;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'car_num')
  final String carNum;
  @JsonKey(name: 'car_model')
  final String carModel;
  @JsonKey(name: 'car_color')
  final String carColor;
  final String status;
  @JsonKey(name: 'lot_id')
  final int? lotId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Vehicle({
    required this.id,
    required this.customerName,
    required this.carNum,
    required this.carModel,
    required this.carColor,
    required this.status,
    this.lotId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  /// Check if vehicle is parked
  bool get isParked => status == 'parked';

  /// Check if vehicle is retrieved
  bool get isRetrieved => status == 'retrieved';
}
