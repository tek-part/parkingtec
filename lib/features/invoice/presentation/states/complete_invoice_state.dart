import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'complete_invoice_state.freezed.dart';

/// Complete Invoice State
/// Manages state for completing invoices
@freezed
class CompleteInvoiceState with _$CompleteInvoiceState {
  const factory CompleteInvoiceState.initial() = _Initial;
  const factory CompleteInvoiceState.loading() = _Loading;
  const factory CompleteInvoiceState.success({required Invoice invoice}) = _Success;
  const factory CompleteInvoiceState.error({required Failure failure}) = _Error;
}

