import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'invoice_response.g.dart';

/// Invoice response model
@JsonSerializable()
class InvoiceResponse {
  final Invoice invoice;
  final String message;
  final bool success;

  const InvoiceResponse({
    required this.invoice,
    required this.message,
    this.success = true,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceResponseToJson(this);
}
