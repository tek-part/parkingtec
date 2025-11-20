import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/presentation/states/create_invoice_state.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';

/// Create Invoice Controller
/// Manages state for creating invoices
class CreateInvoiceController extends StateNotifier<CreateInvoiceState> {
  final Ref ref;
  bool _isDisposed = false;

  CreateInvoiceController(this.ref) : super(const CreateInvoiceState.initial()) {
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  void _safeSetState(CreateInvoiceState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Create new invoice
  Future<void> createInvoice(
    CreateInvoiceRequest request, {
    bool skipPrinting = false,
  }) async {
    if (_isDisposed) return;
    _safeSetState(const CreateInvoiceState.loading());

    try {
      final createInvoiceUseCase = ref.read(createInvoiceUseCaseProvider);
      final result = await createInvoiceUseCase.execute(request);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(CreateInvoiceState.error(failure: failure));
        },
        (invoice) {
          _safeSetState(CreateInvoiceState.success(invoice: invoice));
          // Refresh list controllers after a delay to allow dialog to close
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!_isDisposed) {
              ref.read(allInvoicesControllerProvider.notifier).loadAllInvoices();
              ref.read(activeInvoicesControllerProvider.notifier).loadActiveInvoices();
            }
          });

          // Auto-print entry ticket (side-effect, non-blocking)
          // Only print if skipPrinting is false
          if (!skipPrinting) {
            _printEntryTicket(invoice);
          }
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(CreateInvoiceState.error(failure: ServerFailure(e.toString())));
      }
    }
  }

  /// Print entry ticket (side-effect, non-blocking)
  void _printEntryTicket(invoice) {
    // Run asynchronously without blocking
    Future.microtask(() async {
      try {
        final appConfig = ref.read(appConfigProvider);
        if (appConfig == null) return;

        final printUseCase = ref.read(printInvoiceOnCreateUseCaseProvider);
        await printUseCase.printEntryTicket(invoice, appConfig.toModel());
        // Errors are logged but don't affect invoice creation
      } catch (e) {
        // Silently handle errors - printing is a side-effect
      }
    });
  }
}

