import 'package:json_annotation/json_annotation.dart';

part 'scan_response.g.dart';

/// Scan response model
@JsonSerializable()
class ScanResponse {
  final String message;
  final bool success;

  const ScanResponse({required this.message, this.success = true});

  factory ScanResponse.fromJson(Map<String, dynamic> json) =>
      _$ScanResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ScanResponseToJson(this);
}

