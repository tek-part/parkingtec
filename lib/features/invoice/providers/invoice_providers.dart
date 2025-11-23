import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/presentation/controllers/active_invoices_controller.dart';
import 'package:parkingtec/features/invoice/presentation/controllers/all_invoices_controller.dart';
import 'package:parkingtec/features/invoice/presentation/controllers/complete_invoice_controller.dart';
import 'package:parkingtec/features/invoice/presentation/controllers/create_invoice_controller.dart';
import 'package:parkingtec/features/invoice/presentation/controllers/invoice_details_controller.dart';
import 'package:parkingtec/features/invoice/presentation/controllers/pending_invoices_controller.dart';
import 'package:parkingtec/features/invoice/presentation/states/active_invoices_state.dart';
import 'package:parkingtec/features/invoice/presentation/states/all_invoices_state.dart';
import 'package:parkingtec/features/invoice/presentation/states/complete_invoice_state.dart';
import 'package:parkingtec/features/invoice/presentation/states/create_invoice_state.dart';
import 'package:parkingtec/features/invoice/presentation/states/invoice_details_state.dart';
import 'package:parkingtec/features/invoice/presentation/states/pending_invoices_state.dart';

// ============================================================================
// All Invoices Controllers & Providers
// ============================================================================

/// All Invoices Controller Provider
final allInvoicesControllerProvider =
    StateNotifierProvider<AllInvoicesController, AllInvoicesState>(
  (ref) => AllInvoicesController(ref),
);

/// All Invoices Provider
/// Returns all invoices from the loaded state
final allInvoicesProvider = Provider<List<Invoice>>((ref) {
  return ref.watch(allInvoicesControllerProvider).maybeWhen(
        loaded: (invoices, _) => invoices,
        orElse: () => const [],
      );
});

// ============================================================================
// Active Invoices Controllers & Providers
// ============================================================================

/// Active Invoices Controller Provider
final activeInvoicesControllerProvider =
    StateNotifierProvider<ActiveInvoicesController, ActiveInvoicesState>(
  (ref) => ActiveInvoicesController(ref),
);

/// Active Invoices Provider
/// Returns active invoices from the loaded state
final activeInvoicesProvider = Provider<List<Invoice>>((ref) {
  return ref.watch(activeInvoicesControllerProvider).maybeWhen(
        loaded: (invoices, _) => invoices,
        orElse: () => const [],
      );
});

// ============================================================================
// Pending Invoices Controllers & Providers
// ============================================================================

/// Pending Invoices Controller Provider
final pendingInvoicesControllerProvider =
    StateNotifierProvider<PendingInvoicesController, PendingInvoicesState>(
  (ref) => PendingInvoicesController(ref),
);

/// Pending Invoices Provider
/// Returns pending invoices from the loaded state
final pendingInvoicesProvider = Provider<List<Invoice>>((ref) {
  return ref.watch(pendingInvoicesControllerProvider).maybeWhen(
        loaded: (invoices, _) => invoices,
        orElse: () => const [],
      );
});

// ============================================================================
// Create Invoice Controllers & Providers
// ============================================================================

/// Create Invoice Controller Provider
final createInvoiceControllerProvider =
    StateNotifierProvider<CreateInvoiceController, CreateInvoiceState>(
  (ref) => CreateInvoiceController(ref),
);

// ============================================================================
// Invoice Details Controllers & Providers
// ============================================================================

/// Invoice Details Controller Provider (with family for invoiceId)
final invoiceDetailsControllerProvider =
    StateNotifierProvider.family<InvoiceDetailsController, InvoiceDetailsState, int>(
  (ref, invoiceId) => InvoiceDetailsController(ref, invoiceId),
);

/// Current Invoice Provider
/// Returns the currently selected invoice from details controller
final currentInvoiceProvider = Provider.family<Invoice?, int>((ref, invoiceId) {
  return ref.watch(invoiceDetailsControllerProvider(invoiceId)).maybeWhen(
        loaded: (invoice) => invoice,
        orElse: () => null,
      );
});

// ============================================================================
// Complete Invoice Controllers & Providers
// ============================================================================

/// Complete Invoice Controller Provider
final completeInvoiceControllerProvider =
    StateNotifierProvider<CompleteInvoiceController, CompleteInvoiceState>(
  (ref) => CompleteInvoiceController(ref),
);

// ============================================================================
// Helper Providers (for backward compatibility during migration)
// ============================================================================

/// Invoice Loading Provider (checks if any list is loading)
final invoiceLoadingProvider = Provider<bool>((ref) {
  return ref.watch(allInvoicesControllerProvider).maybeWhen(
            loading: () => true,
            orElse: () => false,
          ) ||
      ref.watch(activeInvoicesControllerProvider).maybeWhen(
            loading: () => true,
            orElse: () => false,
          ) ||
      ref.watch(pendingInvoicesControllerProvider).maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
});

/// Invoice Error Provider (returns first error found)
final invoiceErrorProvider = Provider<String?>((ref) {
  return ref.watch(allInvoicesControllerProvider).maybeWhen(
        error: (failure) => failure.message,
        orElse: () => ref.watch(activeInvoicesControllerProvider).maybeWhen(
              error: (failure) => failure.message,
              orElse: () => ref.watch(pendingInvoicesControllerProvider).maybeWhen(
                    error: (failure) => failure.message,
                    orElse: () => null,
                  ),
            ),
      );
});
