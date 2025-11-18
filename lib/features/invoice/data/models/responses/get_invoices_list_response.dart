import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'get_invoices_list_response.g.dart';

/// Get invoices list response model
/// Matches API response structure: { "data": [...], "message": "..." }
@JsonSerializable()
class GetInvoicesListResponse {
  @JsonKey(name: 'data')
  final List<Invoice>? invoices;

  final String? message;

  const GetInvoicesListResponse({
    this.invoices,
    this.message,
  });

  factory GetInvoicesListResponse.fromJson(Map<String, dynamic> json) =>
      _$GetInvoicesListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetInvoicesListResponseToJson(this);
}

