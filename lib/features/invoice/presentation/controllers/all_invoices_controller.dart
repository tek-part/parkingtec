import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/presentation/states/all_invoices_state.dart';

/// All Invoices Controller
/// Manages state for loading all invoices
class AllInvoicesController extends StateNotifier<AllInvoicesState> {
  final Ref ref;
  bool _isDisposed = false;

  AllInvoicesController(this.ref) : super(const AllInvoicesState.initial()) {
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  void _safeSetState(AllInvoicesState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Load all invoices
  Future<void> loadAllInvoices({String? carNum}) async {
    if (_isDisposed) return;
    _safeSetState(const AllInvoicesState.loading());

    try {
      final getAllInvoicesUseCase = ref.read(getAllInvoicesUseCaseProvider);
      final result = await getAllInvoicesUseCase.execute(carNum: carNum);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(AllInvoicesState.error(failure: failure));
        },
        (invoices) {
          _safeSetState(AllInvoicesState.loaded(
            invoices: invoices,
            searchQuery: carNum ?? '',
          ));
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(AllInvoicesState.error(failure: ServerFailure(e.toString())));
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
        _safeSetState(AllInvoicesState.loaded(invoices: filtered, searchQuery: query));
      },
      orElse: () {},
    );
  }

  /// Clear search query and reload all invoices
  void clearSearch() {
    loadAllInvoices();
  }
}

