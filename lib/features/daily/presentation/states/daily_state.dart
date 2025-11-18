import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';

part 'daily_state.freezed.dart';

/// Daily state using Freezed union types
/// Represents different states of daily shift operations
@freezed
class DailyState with _$DailyState {
  /// Initial state - no operation yet
  const factory DailyState.initial() = _Initial;

  /// Loading state - operation in progress
  const factory DailyState.loading() = _Loading;

  /// Loaded state - daily data loaded successfully
  const factory DailyState.loaded({
    Daily? currentDaily,
    @Default([]) List<Daily> dailyHistory,
  }) = _Loaded;

  /// Error state - operation failed
  const factory DailyState.error({required Failure failure}) = _Error;
}
