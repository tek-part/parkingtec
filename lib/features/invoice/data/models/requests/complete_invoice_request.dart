import 'package:json_annotation/json_annotation.dart';

part 'complete_invoice_request.g.dart';

/// Complete invoice request model
@JsonSerializable()
class CompleteInvoiceRequest {
  @JsonKey(name: 'invoice_id')
  final int invoiceId;
  final double? amount;

  const CompleteInvoiceRequest({
    required this.invoiceId,
    this.amount,
  });

  factory CompleteInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteInvoiceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CompleteInvoiceRequestToJson(this);
}

