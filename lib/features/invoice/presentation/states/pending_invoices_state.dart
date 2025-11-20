import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'pending_invoices_state.freezed.dart';

/// Pending Invoices State
/// Manages state for loading pending invoices
@freezed
class PendingInvoicesState with _$PendingInvoicesState {
  const factory PendingInvoicesState.initial() = _Initial;
  const factory PendingInvoicesState.loading() = _Loading;
  const factory PendingInvoicesState.loaded({
    required List<Invoice> invoices,
    @Default('') String searchQuery,
  }) = _Loaded;
  const factory PendingInvoicesState.error({required Failure failure}) = _Error;
}

