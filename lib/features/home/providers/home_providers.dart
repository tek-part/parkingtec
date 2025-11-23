import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/features/lot/models/lot.dart';

// Home State
class HomeState {
  final bool isLoading;
  final List<Lot> lots;
  final String? error;

  const HomeState({this.isLoading = false, this.lots = const [], this.error});

  HomeState copyWith({bool? isLoading, List<Lot>? lots, String? error}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      lots: lots ?? this.lots,
      error: error ?? this.error,
    );
  }
}

// Home Notifier
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState());

  Future<void> loadLots() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Load lots from API
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false, lots: []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(),
);

final lotsProvider = Provider<List<Lot>>((ref) {
  return ref.watch(homeNotifierProvider).lots;
});

final homeLoadingProvider = Provider<bool>((ref) {
  return ref.watch(homeNotifierProvider).isLoading;
});

final homeErrorProvider = Provider<String?>((ref) {
  return ref.watch(homeNotifierProvider).error;
});
