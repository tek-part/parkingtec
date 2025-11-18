import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';

part 'auth_state.freezed.dart';

/// Authentication state using Freezed union types
/// Represents different states of authentication flow
@freezed
class AuthState with _$AuthState {
  /// Initial state - no authentication attempt yet
  const factory AuthState.initial() = _Initial;

  /// Loading state - authentication operation in progress
  const factory AuthState.loading() = _Loading;

  /// Loaded state - user is authenticated
  const factory AuthState.loaded({
    required User user,
    required bool hasActiveDaily,
  }) = _Loaded;

  /// Error state - authentication failed
  const factory AuthState.error({required Failure failure}) = _Error;
}
