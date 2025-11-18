import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'get_invoice_response.g.dart';

/// Get invoice response model
/// Matches API response structure: { "data": {...}, "message": "..." }
@JsonSerializable()
class GetInvoiceResponse {
  @JsonKey(name: 'data')
  final Invoice? invoice;

  final String? message;

  const GetInvoiceResponse({
    this.invoice,
    this.message,
  });

  factory GetInvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetInvoiceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetInvoiceResponseToJson(this);
}

