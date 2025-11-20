import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/presentation/states/pending_invoices_state.dart';

/// Pending Invoices Controller
/// Manages state for loading pending invoices
class PendingInvoicesController extends StateNotifier<PendingInvoicesState> {
  final Ref ref;
  bool _isDisposed = false;

  PendingInvoicesController(this.ref) : super(const PendingInvoicesState.initial()) {
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  void _safeSetState(PendingInvoicesState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Load pending invoices
  Future<void> loadPendingInvoices() async {
    if (_isDisposed) return;
    _safeSetState(const PendingInvoicesState.loading());

    try {
      final getPendingInvoicesUseCase = ref.read(getPendingInvoicesUseCaseProvider);
      final result = await getPendingInvoicesUseCase.execute();
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(PendingInvoicesState.error(failure: failure));
        },
        (invoices) {
          _safeSetState(PendingInvoicesState.loaded(
            invoices: invoices,
            searchQuery: '',
          ));
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(PendingInvoicesState.error(failure: ServerFailure(e.toString())));
      }
    }
  }

  /// Search in already loaded invoices (no API call)
  void searchInLoadedInvoices(String query) {
    final currentState = state;
    currentState.maybeWhen(
      loaded: (invoices, _) {
        final filtered = invoices.where((invoice) =>
          invoice.carNum.toLowerCase().contains(query.toLowerCase()) ||
          (invoice.customerName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (invoice.carModel?.toLowerCase().contains(query.toLowerCase()) ?? false)
        ).toList();
        _safeSetState(PendingInvoicesState.loaded(invoices: filtered, searchQuery: query));
      },
      orElse: () {},
    );
  }

  /// Clear search query and reload pending invoices
  void clearSearch() {
    loadPendingInvoices();
  }
}

