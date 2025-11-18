import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/domain/entities/app_config_entity.dart';

part 'config_state.freezed.dart';

/// Config state using Freezed union types
/// Represents different states of app config operations
@freezed
class ConfigState with _$ConfigState {
  /// Initial state - no operation yet
  const factory ConfigState.initial() = _Initial;

  /// Loading state - operation in progress
  const factory ConfigState.loading() = _Loading;

  /// Loaded state - config data loaded successfully
  const factory ConfigState.loaded(AppConfigEntity config) = _Loaded;

  /// Error state - operation failed
  const factory ConfigState.error({required Failure failure}) = _Error;
}

