import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'pay_invoice_response.g.dart';

/// Pay invoice response model
/// Matches API response structure: { "data": {...}, "message": "..." }
@JsonSerializable()
class PayInvoiceResponse {
  @JsonKey(name: 'data')
  final PayInvoiceData? data;

  final String? message;

  const PayInvoiceResponse({
    this.data,
    this.message,
  });

  factory PayInvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$PayInvoiceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PayInvoiceResponseToJson(this);
}

@JsonSerializable()
class PayInvoiceData {
  final Invoice? invoice;
  @JsonKey(name: 'paid_amount')
  final double? paidAmount;
  final String? status;

  const PayInvoiceData({
    this.invoice,
    this.paidAmount,
    this.status,
  });

  factory PayInvoiceData.fromJson(Map<String, dynamic> json) =>
      _$PayInvoiceDataFromJson(json);
  Map<String, dynamic> toJson() => _$PayInvoiceDataToJson(this);
}

