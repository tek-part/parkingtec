import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

part 'invoice_state.freezed.dart';

/// Invoice state using Freezed union types
/// Represents different states of invoice operations
@freezed
class InvoiceState with _$InvoiceState {
  /// Initial state - no operation yet
  const factory InvoiceState.initial() = _Initial;

  /// Loading state - operation in progress
  const factory InvoiceState.loading() = _Loading;

  /// Loaded state - invoices loaded successfully
  const factory InvoiceState.loaded({
    required List<Invoice> allInvoices,
    required List<Invoice> activeInvoices,
    required List<Invoice> pendingInvoices,
    Invoice? currentInvoice,
    @Default('') String searchQuery,
  }) = _Loaded;

  /// Error state - operation failed
  const factory InvoiceState.error({required Failure failure}) = _Error;
}
