import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/presentation/states/invoice_details_state.dart';

/// Invoice Details Controller
/// Manages state for loading single invoice details
class InvoiceDetailsController extends StateNotifier<InvoiceDetailsState> {
  final Ref ref;
  final int invoiceId;
  bool _isDisposed = false;

  InvoiceDetailsController(this.ref, this.invoiceId) : super(const InvoiceDetailsState.initial()) {
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  void _safeSetState(InvoiceDetailsState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Load specific invoice by ID
  Future<void> loadInvoice() async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceDetailsState.loading());

    try {
      final getInvoiceUseCase = ref.read(getInvoiceUseCaseProvider);
      final result = await getInvoiceUseCase.execute(invoiceId);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceDetailsState.error(failure: failure));
        },
        (invoice) {
          _safeSetState(InvoiceDetailsState.loaded(invoice: invoice));
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(InvoiceDetailsState.error(failure: ServerFailure(e.toString())));
      }
    }
  }
}

