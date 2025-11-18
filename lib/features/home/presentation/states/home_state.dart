import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/lot/models/lot.dart';

part 'home_state.freezed.dart';

/// Home state using Freezed union types
/// Represents different states of home/lot operations
@freezed
class HomeState with _$HomeState {
  /// Initial state - no operation yet
  const factory HomeState.initial() = _Initial;

  /// Loading state - operation in progress
  const factory HomeState.loading() = _Loading;

  /// Loaded state - lots loaded successfully
  const factory HomeState.loaded({@Default([]) List<Lot> lots}) = _Loaded;

  /// Error state - operation failed
  const factory HomeState.error({required Failure failure}) = _Error;
}
