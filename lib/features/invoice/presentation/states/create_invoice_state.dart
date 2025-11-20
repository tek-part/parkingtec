import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'create_invoice_state.freezed.dart';

/// Create Invoice State
/// Manages state for creating invoices
@freezed
class CreateInvoiceState with _$CreateInvoiceState {
  const factory CreateInvoiceState.initial() = _Initial;
  const factory CreateInvoiceState.loading() = _Loading;
  const factory CreateInvoiceState.success({required Invoice invoice}) = _Success;
  const factory CreateInvoiceState.error({required Failure failure}) = _Error;
}

