import 'package:json_annotation/json_annotation.dart';

part 'create_invoice_request.g.dart';

/// Create invoice request model
@JsonSerializable()
class CreateInvoiceRequest {
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @JsonKey(name: 'car_num')
  final String carNum;
  @JsonKey(name: 'car_model')
  final String? carModel;
  final double? amount;

  const CreateInvoiceRequest({
    this.customerName,
    required this.carNum,
    this.carModel,
    this.amount,
  });

  factory CreateInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateInvoiceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateInvoiceRequestToJson(this);
}

