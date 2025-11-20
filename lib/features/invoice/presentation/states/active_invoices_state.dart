import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'active_invoices_state.freezed.dart';

/// Active Invoices State
/// Manages state for loading active invoices
@freezed
class ActiveInvoicesState with _$ActiveInvoicesState {
  const factory ActiveInvoicesState.initial() = _Initial;
  const factory ActiveInvoicesState.loading() = _Loading;
  const factory ActiveInvoicesState.loaded({
    required List<Invoice> invoices,
    @Default('') String searchQuery,
  }) = _Loaded;
  const factory ActiveInvoicesState.error({required Failure failure}) = _Error;
}

