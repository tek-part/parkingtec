import 'package:json_annotation/json_annotation.dart';

part 'receipt.g.dart';

/// Receipt model for parking receipts
@JsonSerializable()
class Receipt {
  final int id;
  @JsonKey(name: 'invoice_id')
  final int invoiceId;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'car_num')
  final String carNum;
  @JsonKey(name: 'car_model')
  final String carModel;
  final double amount;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String? endTime;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const Receipt({
    required this.id,
    required this.invoiceId,
    required this.customerName,
    required this.carNum,
    required this.carModel,
    required this.amount,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  /// Check if receipt is active
  bool get isActive => status == 'active';

  /// Check if receipt is completed
  bool get isCompleted => status == 'completed';
}
