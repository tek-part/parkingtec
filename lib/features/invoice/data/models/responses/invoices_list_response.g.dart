// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoices_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoicesListResponse _$InvoicesListResponseFromJson(
        Map<String, dynamic> json) =>
    InvoicesListResponse(
      invoices: (json['invoices'] as List<dynamic>)
          .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$InvoicesListResponseToJson(
        InvoicesListResponse instance) =>
    <String, dynamic>{
      'invoices': instance.invoices,
      'message': instance.message,
      'success': instance.success,
    };
