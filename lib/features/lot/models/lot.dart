import 'package:json_annotation/json_annotation.dart';

part 'lot.g.dart';

/// Lot model for parking lots
@JsonSerializable()
class Lot {
  final int id;
  final String name;
  final String location;
  final int capacity;
  final int occupied;
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Lot({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.occupied,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);
  Map<String, dynamic> toJson() => _$LotToJson(this);

  /// Check if lot is available
  bool get isAvailable => isActive && occupied < capacity;

  /// Get available spaces
  int get availableSpaces => capacity - occupied;
}
