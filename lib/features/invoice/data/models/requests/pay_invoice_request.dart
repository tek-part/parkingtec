import 'package:json_annotation/json_annotation.dart';

part 'pay_invoice_request.g.dart';

/// Pay invoice request model
@JsonSerializable()
class PayInvoiceRequest {
  final double amount;

  const PayInvoiceRequest({required this.amount});

  factory PayInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$PayInvoiceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PayInvoiceRequestToJson(this);
}

