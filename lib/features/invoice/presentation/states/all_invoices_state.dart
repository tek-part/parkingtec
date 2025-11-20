import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'all_invoices_state.freezed.dart';

/// All Invoices State
/// Manages state for loading all invoices
@freezed
class AllInvoicesState with _$AllInvoicesState {
  const factory AllInvoicesState.initial() = _Initial;
  const factory AllInvoicesState.loading() = _Loading;
  const factory AllInvoicesState.loaded({
    required List<Invoice> invoices,
    @Default('') String searchQuery,
  }) = _Loaded;
  const factory AllInvoicesState.error({required Failure failure}) = _Error;
}

