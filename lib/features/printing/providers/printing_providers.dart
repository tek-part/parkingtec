import 'package:flutter_riverpod/flutter_riverpod.dart';

// Printing State
class PrintingState {
  final bool isLoading;
  final bool isPrinting;
  final String? error;
  final String? lastPrintJob;

  const PrintingState({
    this.isLoading = false,
    this.isPrinting = false,
    this.error,
    this.lastPrintJob,
  });

  PrintingState copyWith({
    bool? isLoading,
    bool? isPrinting,
    String? error,
    String? lastPrintJob,
  }) {
    return PrintingState(
      isLoading: isLoading ?? this.isLoading,
      isPrinting: isPrinting ?? this.isPrinting,
      error: error ?? this.error,
      lastPrintJob: lastPrintJob ?? this.lastPrintJob,
    );
  }
}

// Printing Notifier
class PrintingNotifier extends StateNotifier<PrintingState> {
  PrintingNotifier() : super(const PrintingState());

  Future<void> printReceipt({
    required String content,
    required String type,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement printing logic
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(
        isLoading: false,
        lastPrintJob: 'Receipt printed successfully',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> printInvoice({
    required String content,
    required String type,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement printing logic
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(
        isLoading: false,
        lastPrintJob: 'Invoice printed successfully',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearLastPrintJob() {
    state = state.copyWith(lastPrintJob: null);
  }
}

// Providers
final printingNotifierProvider =
    StateNotifierProvider<PrintingNotifier, PrintingState>(
      (ref) => PrintingNotifier(),
    );

final printingLoadingProvider = Provider<bool>((ref) {
  return ref.watch(printingNotifierProvider).isLoading;
});

final printingErrorProvider = Provider<String?>((ref) {
  return ref.watch(printingNotifierProvider).error;
});

final lastPrintJobProvider = Provider<String?>((ref) {
  return ref.watch(printingNotifierProvider).lastPrintJob;
});
