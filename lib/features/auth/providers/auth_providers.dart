import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';
import 'package:parkingtec/features/auth/presentation/controllers/auth_controller.dart';
import 'package:parkingtec/features/auth/presentation/states/auth_state.dart';

/// Authentication Providers
/// Exposes authentication state and business logic via Riverpod providers

// ==================== RIVERPOD PROVIDERS ====================

/// Main authentication controller provider
final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>(
      (ref) => AuthController(ref),
    );

/// Provider for authentication status
final isAuthenticatedProvider = Provider.autoDispose<bool>((ref) {
  return ref
      .watch(authControllerProvider)
      .maybeWhen(loaded: (_, __) => true, orElse: () => false);
});

/// Provider for current user data
final currentUserProvider = Provider.autoDispose<User?>((ref) {
  return ref
      .watch(authControllerProvider)
      .maybeWhen(loaded: (user, _) => user, orElse: () => null);
});

/// Provider for authentication loading state
final authLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref
      .watch(authControllerProvider)
      .maybeWhen(loading: () => true, orElse: () => false);
});

/// Provider for authentication errors
final authErrorProvider = Provider.autoDispose<Failure?>((ref) {
  return ref
      .watch(authControllerProvider)
      .maybeWhen(error: (failure) => failure, orElse: () => null);
});

/// Provider for daily shift status
final hasActiveDailyProvider = Provider.autoDispose<bool>((ref) {
  return ref
      .watch(authControllerProvider)
      .maybeWhen(
        loaded: (_, hasActiveDaily) => hasActiveDaily,
        orElse: () => false,
      );
});
