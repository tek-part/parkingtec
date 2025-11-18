import 'package:json_annotation/json_annotation.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'invoices_list_response.g.dart';

/// Invoices list response model
@JsonSerializable()
class InvoicesListResponse {
  final List<Invoice> invoices;
  final String message;
  final bool success;

  const InvoicesListResponse({
    required this.invoices,
    required this.message,
    this.success = true,
  });

  factory InvoicesListResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoicesListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InvoicesListResponseToJson(this);
}
