import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/daily/data/models/requests/start_daily_request.dart';
import 'package:parkingtec/features/daily/data/models/requests/terminate_daily_request.dart';
import 'package:parkingtec/features/daily/presentation/states/daily_state.dart';

/// Daily controller (ViewModel)
/// Manages daily shift state and business logic
/// Uses StateNotifier for state management
class DailyController extends StateNotifier<DailyState> {
  final Ref ref;
  bool _isDisposed = false;

  DailyController(this.ref) : super(const DailyState.initial()) {
    // Keep alive during async operations
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  /// Safely update state only if not disposed
  void _safeSetState(DailyState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Start daily shift
  /// Validates input and calls StartDailyUseCase
  Future<void> startDaily(double? startBalance, String? notes) async {
    if (_isDisposed) return;
    _safeSetState(const DailyState.loading());

    try {
      // Validate start balance
      if (startBalance == null || startBalance < 0) {
        _safeSetState(
          const DailyState.error(
            failure: ValidationFailure('Start balance is required and must be positive'),
          ),
        );
        return;
      }

      // Create request
      final request = StartDailyRequest(
        startBalance: startBalance,
        notes: notes,
      );

      // Use Riverpod provider to get use case
      final startDailyUseCase = ref.read(startDailyUseCaseProvider);
      final result = await startDailyUseCase.execute(request);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(DailyState.error(failure: failure));
        },
        (daily) {
          _safeSetState(
            DailyState.loaded(
              currentDaily: daily,
              dailyHistory: const [],
            ),
          );
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          DailyState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Get active daily shift
  /// Fetches current active daily from API
  Future<void> getActiveDaily() async {
    if (_isDisposed) return;
    _safeSetState(const DailyState.loading());

    try {
      final getActiveDailyUseCase = ref.read(getActiveDailyUseCaseProvider);
      final result = await getActiveDailyUseCase.execute();
      if (_isDisposed) return;

      result.fold(
        (failure) {
          // If no active daily found, it's not an error - just return empty state
          if (failure is CacheFailure) {
            _safeSetState(
              const DailyState.loaded(
                currentDaily: null,
                dailyHistory: [],
              ),
            );
          } else {
            _safeSetState(DailyState.error(failure: failure));
          }
        },
        (daily) {
          _safeSetState(
            DailyState.loaded(
              currentDaily: daily,
              dailyHistory: const [],
            ),
          );
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          DailyState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }

  /// Terminate daily shift
  /// Validates input and calls TerminateDailyUseCase
  Future<void> terminateDaily(double? endBalance, String? notes) async {
    if (_isDisposed) return;
    _safeSetState(const DailyState.loading());

    try {
      // Validate end balance
      if (endBalance == null || endBalance < 0) {
        _safeSetState(
          const DailyState.error(
            failure: ValidationFailure('End balance is required and must be positive'),
          ),
        );
        return;
      }

      // Create request
      final request = TerminateDailyRequest(
        endBalance: endBalance,
        notes: notes,
      );

      // Use Riverpod provider to get use case
      final terminateDailyUseCase = ref.read(terminateDailyUseCaseProvider);
      final result = await terminateDailyUseCase.execute(request);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(DailyState.error(failure: failure));
        },
        (daily) {
          // After successful termination, set currentDaily to null
          _safeSetState(
            const DailyState.loaded(
              currentDaily: null,
              dailyHistory: [],
            ),
          );
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          DailyState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }
}

