import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/presentation/controllers/daily_controller.dart';
import 'package:parkingtec/features/daily/presentation/states/daily_state.dart';

/// Daily Providers
/// Exposes daily shift state and business logic via Riverpod providers

// ==================== RIVERPOD PROVIDERS ====================

/// Main daily controller provider
final dailyControllerProvider =
    StateNotifierProvider.autoDispose<DailyController, DailyState>(
  (ref) => DailyController(ref),
);

/// Provider for current active daily
final currentDailyProvider = Provider.autoDispose<Daily?>((ref) {
  return ref
      .watch(dailyControllerProvider)
      .maybeWhen(loaded: (daily, _) => daily, orElse: () => null);
});

/// Provider for daily history
final dailyHistoryProvider = Provider.autoDispose<List<Daily>>((ref) {
  return ref
      .watch(dailyControllerProvider)
      .maybeWhen(loaded: (_, history) => history, orElse: () => []);
});

/// Provider for daily loading state
final dailyLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref
      .watch(dailyControllerProvider)
      .maybeWhen(loading: () => true, orElse: () => false);
});

/// Provider for daily errors
final dailyErrorProvider = Provider.autoDispose<Failure?>((ref) {
  return ref
      .watch(dailyControllerProvider)
      .maybeWhen(error: (failure) => failure, orElse: () => null);
});

/// Provider for checking if there's an active daily
final hasActiveDailyProvider = Provider.autoDispose<bool>((ref) {
  final daily = ref.watch(currentDailyProvider);
  return daily != null && (daily.isActive);
});
