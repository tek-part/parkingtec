// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_invoices_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInvoicesListResponse _$GetInvoicesListResponseFromJson(
  Map<String, dynamic> json,
) => GetInvoicesListResponse(
  invoices: (json['data'] as List<dynamic>?)
      ?.map((e) => Invoice.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$GetInvoicesListResponseToJson(
  GetInvoicesListResponse instance,
) => <String, dynamic>{'data': instance.invoices, 'message': instance.message};
