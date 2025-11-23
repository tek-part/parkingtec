import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/presentation/states/complete_invoice_state.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';

/// Complete Invoice Controller
/// Manages state for completing invoices
class CompleteInvoiceController extends StateNotifier<CompleteInvoiceState> {
  final Ref ref;
  bool _isDisposed = false;

  CompleteInvoiceController(this.ref)
    : super(const CompleteInvoiceState.initial()) {
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  void _safeSetState(CompleteInvoiceState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Complete invoice
  Future<void> completeInvoice(
    CompleteInvoiceRequest request, {
    bool skipPrinting = false,
  }) async {
    if (_isDisposed) return;
    _safeSetState(const CompleteInvoiceState.loading());

    try {
      final completeInvoiceUseCase = ref.read(completeInvoiceUseCaseProvider);
      final result = await completeInvoiceUseCase.execute(request);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(CompleteInvoiceState.error(failure: failure));
        },
        (invoice) {
          _safeSetState(CompleteInvoiceState.success(invoice: invoice));
          // Refresh all list controllers
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!_isDisposed) {
              ref
                  .read(allInvoicesControllerProvider.notifier)
                  .loadAllInvoices();
              ref
                  .read(activeInvoicesControllerProvider.notifier)
                  .loadActiveInvoices();
              ref
                  .read(pendingInvoicesControllerProvider.notifier)
                  .loadPendingInvoices();
            }
          });

          // Auto-print exit receipt (side-effect, non-blocking)
          // Only print if skipPrinting is false
          if (!skipPrinting) {
            _printExitReceipt(invoice);
          }
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          CompleteInvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Print exit receipt (side-effect, non-blocking)
  void _printExitReceipt(invoice) {
    // Run asynchronously without blocking
    Future.microtask(() async {
      try {
        final appConfig = ref.read(appConfigProvider);
        if (appConfig == null) return;

        final printUseCase = ref.read(printInvoiceOnCompleteUseCaseProvider);
        await printUseCase.printExitReceipt(invoice, appConfig.toModel());
        // Errors are logged but don't affect invoice completion
      } catch (e) {
        // Silently handle errors - printing is a side-effect
      }
    });
  }
}
