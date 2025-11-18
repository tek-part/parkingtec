import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/pay_invoice_request.dart';
import 'package:parkingtec/features/invoice/presentation/states/invoice_state.dart';

/// Invoice Controller (ViewModel)
/// Manages invoice state and business logic
/// Uses StateNotifier for state management
class InvoiceController extends StateNotifier<InvoiceState> {
  final Ref ref;
  bool _isDisposed = false;

  InvoiceController(this.ref) : super(const InvoiceState.initial()) {
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  void _safeSetState(InvoiceState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Load all invoices
  Future<void> loadAllInvoices({String? carNum}) async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final getAllInvoicesUseCase = ref.read(getAllInvoicesUseCaseProvider);
      final result = await getAllInvoicesUseCase.execute(carNum: carNum);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoices) {
          final currentState = state;
          currentState.maybeWhen(
            loaded: (all, active, pending, current, query) {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: invoices,
                  activeInvoices: active,
                  pendingInvoices: pending,
                  currentInvoice: current,
                  searchQuery: carNum ?? query,
                ),
              );
            },
            orElse: () {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: invoices,
                  activeInvoices: const [],
                  pendingInvoices: const [],
                  searchQuery: carNum ?? '',
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Load active invoices
  Future<void> loadActiveInvoices() async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final getActiveInvoicesUseCase = ref.read(getActiveInvoicesUseCaseProvider);
      final result = await getActiveInvoicesUseCase.execute();
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoices) {
          final currentState = state;
          currentState.maybeWhen(
            loaded: (all, active, pending, current, query) {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: all,
                  activeInvoices: invoices,
                  pendingInvoices: pending,
                  currentInvoice: current,
                  searchQuery: query,
                ),
              );
            },
            orElse: () {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: const [],
                  activeInvoices: invoices,
                  pendingInvoices: const [],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Load pending invoices
  Future<void> loadPendingInvoices() async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final getPendingInvoicesUseCase = ref.read(getPendingInvoicesUseCaseProvider);
      final result = await getPendingInvoicesUseCase.execute();
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoices) {
          final currentState = state;
          currentState.maybeWhen(
            loaded: (all, active, pending, current, query) {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: all,
                  activeInvoices: active,
                  pendingInvoices: invoices,
                  currentInvoice: current,
                  searchQuery: query,
                ),
              );
            },
            orElse: () {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: const [],
                  activeInvoices: const [],
                  pendingInvoices: invoices,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Load all invoice lists (all, active, pending)
  Future<void> loadAllInvoiceLists() async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final getAllInvoicesUseCase = ref.read(getAllInvoicesUseCaseProvider);
      final getActiveInvoicesUseCase = ref.read(getActiveInvoicesUseCaseProvider);
      final getPendingInvoicesUseCase = ref.read(getPendingInvoicesUseCaseProvider);

      final results = await Future.wait([
        getAllInvoicesUseCase.execute(),
        getActiveInvoicesUseCase.execute(),
        getPendingInvoicesUseCase.execute(),
      ]);

      if (_isDisposed) return;

      // Check for errors
      for (final result in results) {
        result.fold(
          (failure) {
            _safeSetState(InvoiceState.error(failure: failure));
            return;
          },
          (_) {},
        );
      }

      // All succeeded
      final allResult = results[0];
      final activeResult = results[1];
      final pendingResult = results[2];

      allResult.fold(
        (_) {},
        (allInvoices) {
          activeResult.fold(
            (_) {},
            (activeInvoices) {
              pendingResult.fold(
                (_) {},
                (pendingInvoices) {
                  final currentState = state;
                  Invoice? currentInvoice;
                  String searchQuery = '';
                  
                  currentState.maybeWhen(
                    loaded: (_, __, ___, current, query) {
                      currentInvoice = current;
                      searchQuery = query;
                    },
                    orElse: () {},
                  );
                  
                  _safeSetState(
                    InvoiceState.loaded(
                      allInvoices: allInvoices,
                      activeInvoices: activeInvoices,
                      pendingInvoices: pendingInvoices,
                      currentInvoice: currentInvoice,
                      searchQuery: searchQuery,
                    ),
                  );
                },
              );
            },
          );
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Load specific invoice by ID
  /// Preserves existing invoice lists to avoid clearing them
  /// Clears currentInvoice if loading a different invoice
  Future<void> loadInvoice(int invoiceId) async {
    if (_isDisposed) return;
    
    // Preserve current state if it's loaded (to keep invoice lists)
    final currentState = state;
    final hasLoadedData = currentState.maybeWhen(
      loaded: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );

    // Check if we're loading a different invoice
    final currentInvoiceId = currentState.maybeWhen(
      loaded: (_, __, ___, current, ____) => current?.invoiceId,
      orElse: () => null,
    );

    // Clear current invoice if loading a different one
    if (currentInvoiceId != null && currentInvoiceId != invoiceId) {
      currentState.maybeWhen(
        loaded: (all, active, pending, _, query) {
          _safeSetState(
            InvoiceState.loaded(
              allInvoices: all,
              activeInvoices: active,
              pendingInvoices: pending,
              currentInvoice: null, // Clear old invoice
              searchQuery: query,
            ),
          );
        },
        orElse: () {},
      );
    }

    // Only set loading if we don't have loaded data
    if (!hasLoadedData) {
      _safeSetState(const InvoiceState.loading());
    }

    try {
      final getInvoiceUseCase = ref.read(getInvoiceUseCaseProvider);
      final result = await getInvoiceUseCase.execute(invoiceId);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          // Only show error if we don't have loaded data
          if (!hasLoadedData) {
            _safeSetState(InvoiceState.error(failure: failure));
          }
          // If we have loaded data, just keep it (don't show error for single invoice load)
        },
        (invoice) {
          final currentStateAfterLoad = state;
          currentStateAfterLoad.maybeWhen(
            loaded: (all, active, pending, _, query) {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: all,
                  activeInvoices: active,
                  pendingInvoices: pending,
                  currentInvoice: invoice,
                  searchQuery: query,
                ),
              );
            },
            orElse: () {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: const [],
                  activeInvoices: const [],
                  pendingInvoices: const [],
                  currentInvoice: invoice,
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      if (!_isDisposed && !hasLoadedData) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Create new invoice
  Future<void> createInvoice(CreateInvoiceRequest request) async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final createInvoiceUseCase = ref.read(createInvoiceUseCaseProvider);
      final result = await createInvoiceUseCase.execute(request);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoice) {
          // Reload all lists after creating invoice
          loadAllInvoiceLists();
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Complete invoice
  Future<void> completeInvoice(CompleteInvoiceRequest request) async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final completeInvoiceUseCase = ref.read(completeInvoiceUseCaseProvider);
      final result = await completeInvoiceUseCase.execute(request);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoice) {
          // Update current invoice and reload lists
          final currentState = state;
          currentState.maybeWhen(
            loaded: (all, active, pending, _, query) {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: all,
                  activeInvoices: active,
                  pendingInvoices: pending,
                  currentInvoice: invoice,
                  searchQuery: query,
                ),
              );
            },
            orElse: () {},
          );
          // Reload all lists
          loadAllInvoiceLists();
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Pay invoice
  Future<void> payInvoice(int invoiceId, double amount) async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final payInvoiceUseCase = ref.read(payInvoiceUseCaseProvider);
      final request = PayInvoiceRequest(amount: amount);
      final result = await payInvoiceUseCase.execute(invoiceId, request);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoice) {
          // Update current invoice and reload lists
          final currentState = state;
          currentState.maybeWhen(
            loaded: (all, active, pending, _, query) {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: all,
                  activeInvoices: active,
                  pendingInvoices: pending,
                  currentInvoice: invoice,
                  searchQuery: query,
                ),
              );
            },
            orElse: () {},
          );
          // Reload all lists
          loadAllInvoiceLists();
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Pickup invoice
  Future<void> pickupInvoice(int invoiceId) async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final pickupInvoiceUseCase = ref.read(pickupInvoiceUseCaseProvider);
      final result = await pickupInvoiceUseCase.execute(invoiceId);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoice) {
          // Update current invoice and reload lists
          final currentState = state;
          currentState.maybeWhen(
            loaded: (all, active, pending, _, query) {
              _safeSetState(
                InvoiceState.loaded(
                  allInvoices: all,
                  activeInvoices: active,
                  pendingInvoices: pending,
                  currentInvoice: invoice,
                  searchQuery: query,
                ),
              );
            },
            orElse: () {},
          );
          // Reload all lists
          loadAllInvoiceLists();
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Scan invoice QR code
  Future<void> scanInvoice(int invoiceId) async {
    if (_isDisposed) return;
    _safeSetState(const InvoiceState.loading());

    try {
      final scanInvoiceUseCase = ref.read(scanInvoiceUseCaseProvider);
      final result = await scanInvoiceUseCase.execute(invoiceId);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(InvoiceState.error(failure: failure));
        },
        (invoice) {
          // Load the scanned invoice
          loadInvoice(invoiceId);
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          InvoiceState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Search invoices by car number
  Future<void> searchInvoices(String carNum) async {
    if (carNum.isEmpty) {
      // If search is empty, reload all invoices
      await loadAllInvoices();
      return;
    }

    await loadAllInvoices(carNum: carNum);
  }

  /// Refresh all invoice lists
  Future<void> refreshInvoices() async {
    await loadAllInvoiceLists();
  }

  /// Clear current invoice
  void clearCurrentInvoice() {
    final currentState = state;
    currentState.maybeWhen(
      loaded: (all, active, pending, _, query) {
        _safeSetState(
          InvoiceState.loaded(
            allInvoices: all,
            activeInvoices: active,
            pendingInvoices: pending,
            currentInvoice: null,
            searchQuery: query,
          ),
        );
      },
      orElse: () {},
    );
  }
}

