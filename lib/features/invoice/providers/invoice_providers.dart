import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/presentation/controllers/invoice_controller.dart';
import 'package:parkingtec/features/invoice/presentation/states/invoice_state.dart';

/// Invoice Controller Provider
/// Manages invoice state and business logic
/// Note: Not using autoDispose to preserve state when navigating between pages
final invoiceControllerProvider =
    StateNotifierProvider<InvoiceController, InvoiceState>(
  (ref) => InvoiceController(ref),
);

/// All Invoices Provider
/// Returns all invoices from the loaded state
final allInvoicesProvider = Provider<List<Invoice>>((ref) {
  return ref.watch(invoiceControllerProvider).maybeWhen(
        loaded: (all, _, __, ___, ____) => all,
        orElse: () => const [],
      );
});

/// Active Invoices Provider
/// Returns active invoices from the loaded state
final activeInvoicesProvider = Provider<List<Invoice>>((ref) {
  return ref.watch(invoiceControllerProvider).maybeWhen(
        loaded: (_, active, __, ___, ____) => active,
        orElse: () => const [],
      );
});

/// Pending Invoices Provider
/// Returns pending invoices from the loaded state
final pendingInvoicesProvider = Provider<List<Invoice>>((ref) {
  return ref.watch(invoiceControllerProvider).maybeWhen(
        loaded: (_, __, pending, ___, ____) => pending,
        orElse: () => const [],
      );
});

/// Current Invoice Provider
/// Returns the currently selected invoice
final currentInvoiceProvider = Provider<Invoice?>((ref) {
  return ref.watch(invoiceControllerProvider).maybeWhen(
        loaded: (_, __, ___, current, ____) => current,
        orElse: () => null,
      );
});

/// Invoice Loading Provider
/// Returns true if invoices are currently loading
final invoiceLoadingProvider = Provider<bool>((ref) {
  return ref.watch(invoiceControllerProvider).maybeWhen(
        loading: () => true,
        orElse: () => false,
      );
});

/// Invoice Error Provider
/// Returns error message if invoice operation failed
final invoiceErrorProvider = Provider<String?>((ref) {
  return ref.watch(invoiceControllerProvider).maybeWhen(
        error: (failure) => failure.message,
        orElse: () => null,
      );
});

/// Search Query Provider
/// Returns the current search query
final invoiceSearchQueryProvider = Provider<String>((ref) {
  return ref.watch(invoiceControllerProvider).maybeWhen(
        loaded: (_, __, ___, ____, query) => query,
        orElse: () => '',
      );
});
