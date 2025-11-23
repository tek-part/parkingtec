import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/presentation/states/active_invoices_state.dart';

/// Active Invoices Controller
/// Manages state for loading active invoices
class ActiveInvoicesController extends StateNotifier<ActiveInvoicesState> {
  final Ref ref;
  bool _isDisposed = false;

  ActiveInvoicesController(this.ref) : super(const ActiveInvoicesState.initial()) {
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  void _safeSetState(ActiveInvoicesState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Load active invoices
  Future<void> loadActiveInvoices() async {
    if (_isDisposed) return;
    _safeSetState(const ActiveInvoicesState.loading());

    try {
      final getActiveInvoicesUseCase = ref.read(getActiveInvoicesUseCaseProvider);
      final result = await getActiveInvoicesUseCase.execute();
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(ActiveInvoicesState.error(failure: failure));
        },
        (invoices) {
          _safeSetState(ActiveInvoicesState.loaded(
            invoices: invoices,
            searchQuery: '',
          ));
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(ActiveInvoicesState.error(failure: ServerFailure(e.toString())));
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
        _safeSetState(ActiveInvoicesState.loaded(invoices: filtered, searchQuery: query));
      },
      orElse: () {},
    );
  }

  /// Clear search query and reload active invoices
  void clearSearch() {
    loadActiveInvoices();
  }
}

