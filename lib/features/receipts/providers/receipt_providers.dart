import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/receipt/models/receipt.dart';

// Receipt State
class ReceiptState {
  final bool isLoading;
  final List<Receipt> receipts;
  final Receipt? currentReceipt;
  final String? error;

  const ReceiptState({
    this.isLoading = false,
    this.receipts = const [],
    this.currentReceipt,
    this.error,
  });

  ReceiptState copyWith({
    bool? isLoading,
    List<Receipt>? receipts,
    Receipt? currentReceipt,
    String? error,
  }) {
    return ReceiptState(
      isLoading: isLoading ?? this.isLoading,
      receipts: receipts ?? this.receipts,
      currentReceipt: currentReceipt ?? this.currentReceipt,
      error: error ?? this.error,
    );
  }
}

// Receipt Notifier
class ReceiptNotifier extends StateNotifier<ReceiptState> {
  ReceiptNotifier() : super(const ReceiptState());

  Future<void> loadReceipts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Load receipts from API
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false, receipts: []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createReceipt({
    required String sessionId,
    required double amount,
    required String type,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Create receipt via API
      await Future.delayed(const Duration(seconds: 1));

      final receipt = Receipt(
        id: DateTime.now().millisecondsSinceEpoch,
        invoiceId: 0,
        customerName: '',
        carNum: '',
        carModel: '',
        amount: amount,
        status: 'active',
        startTime: DateTime.now().toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      state = state.copyWith(isLoading: false, currentReceipt: receipt);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final receiptNotifierProvider =
    StateNotifierProvider<ReceiptNotifier, ReceiptState>(
      (ref) => ReceiptNotifier(),
    );

final receiptsProvider = Provider<List<Receipt>>((ref) {
  return ref.watch(receiptNotifierProvider).receipts;
});

final currentReceiptProvider = Provider<Receipt?>((ref) {
  return ref.watch(receiptNotifierProvider).currentReceipt;
});

final receiptLoadingProvider = Provider<bool>((ref) {
  return ref.watch(receiptNotifierProvider).isLoading;
});

final receiptErrorProvider = Provider<String?>((ref) {
  return ref.watch(receiptNotifierProvider).error;
});
