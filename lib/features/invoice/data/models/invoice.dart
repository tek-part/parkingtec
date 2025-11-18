import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

/// Helper function to parse double from String or num
/// Handles cases where API returns numeric values as String or num
double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed;
  }
  return null;
}

/// Invoice model for parking invoices
/// Matches InvoiceResource structure from API
@JsonSerializable()
class Invoice {
  @JsonKey(name: 'invoice_id', defaultValue: 0)
  final int invoiceId;

  @JsonKey(name: 'customer_name')
  final String? customerName;

  @JsonKey(name: 'car_num')
  final String carNum;

  @JsonKey(name: 'car_model')
  final String? carModel;

  @JsonKey(name: 'pricing_type', defaultValue: 'fixed')
  final String pricingType;

  @JsonKey(name: 'amount', fromJson: _parseDouble)
  final double? amount;

  @JsonKey(name: 'final_amount', fromJson: _parseDouble)
  final double? finalAmount;

  @JsonKey(name: 'hourly_rate', fromJson: _parseDouble)
  final double? hourlyRate;

  @JsonKey(name: 'hours', defaultValue: 0.0)
  final double hours;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String? endTime;

  @JsonKey(name: 'start_timestamp')
  final int? startTimestamp;

  @JsonKey(name: 'end_timestamp')
  final int? endTimestamp;

  @JsonKey(name: 'duration_hours', defaultValue: 0.0)
  final double durationHours;

  @JsonKey(name: 'has_qr_code', defaultValue: false)
  final bool hasQrCode;

  @JsonKey(name: 'qr_code')
  final String? qrCode;

  @JsonKey(name: 'status', defaultValue: 'active')
  final String status;

  @JsonKey(name: 'car_status', defaultValue: 'active')
  final String carStatus;

  @JsonKey(name: 'status_label')
  final String? statusLabel;

  @JsonKey(name: 'requested', defaultValue: false)
  final bool requested;

  @JsonKey(name: 'warden_name')
  final String? wardenName;

  @JsonKey(name: 'daily_date')
  final String? dailyDate;

  @JsonKey(name: 'document_url')
  final String? documentUrl;

  // Legacy fields for backward compatibility
  @JsonKey(name: 'id', includeFromJson: false, includeToJson: false)
  int get id => invoiceId;

  @JsonKey(name: 'user_id', includeFromJson: false, includeToJson: false)
  int? get userId => null;

  @JsonKey(name: 'notes', includeFromJson: false, includeToJson: false)
  String? get notes => null;

  @JsonKey(name: 'created_at', includeFromJson: false, includeToJson: false)
  String? get createdAt => startTime;

  @JsonKey(name: 'updated_at', includeFromJson: false, includeToJson: false)
  String? get updatedAt => endTime ?? startTime;

  const Invoice({
    required this.invoiceId,
    this.customerName,
    required this.carNum,
    this.carModel,
    this.pricingType = 'fixed',
    this.amount,
    this.finalAmount,
    this.hourlyRate,
    this.hours = 0.0,
    required this.startTime,
    this.endTime,
    this.startTimestamp,
    this.endTimestamp,
    this.durationHours = 0.0,
    this.hasQrCode = false,
    this.qrCode,
    this.status = 'active',
    this.carStatus = 'active',
    this.statusLabel,
    this.requested = false,
    this.wardenName,
    this.dailyDate,
    this.documentUrl,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  /// Check if invoice is active
  bool get isActive => status == 'active' && carStatus != 'complete';

  /// Check if invoice is pending
  bool get isPending => carStatus == 'pending';

  /// Check if invoice is completed
  bool get isCompleted => status == 'completed' || carStatus == 'complete';

  /// Check if pricing type is fixed
  bool get isFixedPricing => pricingType == 'fixed';

  /// Check if pricing type is hourly
  bool get isHourlyPricing => pricingType == 'hourly';

  /// Get display amount (final_amount or amount)
  double? get displayAmount => finalAmount ?? amount;

  /// Check if invoice is paid (for fixed pricing)
  bool get isPaid => isFixedPricing && (amount != null && amount! > 0);

  /// Get start time as DateTime
  DateTime? get startDateTime {
    try {
      return DateTime.parse(startTime);
    } catch (e) {
      return null;
    }
  }

  /// Get end time as DateTime
  DateTime? get endDateTime {
    if (endTime == null) return null;
    try {
      return DateTime.parse(endTime!);
    } catch (e) {
      return null;
    }
  }
}

