import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/core/services/fcm_service.dart';
import 'package:parkingtec/core/services/secure_storage_service.dart';
import 'package:parkingtec/features/auth/data/models/requests/login_request.dart';
import 'package:parkingtec/features/auth/presentation/states/auth_state.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';

/// Authentication controller (ViewModel)
/// Manages authentication state and business logic
/// Uses StateNotifier for state management
class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  bool _isDisposed = false;

  AuthController(this.ref) : super(const AuthState.initial()) {
    // Keep alive during async operations
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  /// Safely update state only if not disposed
  void _safeSetState(AuthState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Login user with phone and password
  /// Saves authentication token and fetches user profile
  Future<void> login(
    String phone,
    String password, {
    String? deviceToken,
  }) async {
    if (_isDisposed) return;
    _safeSetState(const AuthState.loading());

    try {
      // Get FCM token if not provided
      final fcmToken = deviceToken ?? await FcmService.getFcmToken();
      if (_isDisposed) return;

      final loginRequest = LoginRequest(
        phone: phone,
        password: password,
        deviceToken: fcmToken,
      );

      // Use Riverpod provider to get use case
      final loginUseCase = ref.read(loginUseCaseProvider);
      final result = await loginUseCase.execute(loginRequest);
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(AuthState.error(failure: failure));
        },
        (loginResponse) async {
          if (loginResponse.token != null && loginResponse.user != null) {
            // Save authentication token
            await SecureStorageService.saveToken(loginResponse.token!);
          }
          if (_isDisposed) return;

          // Use user data from login response (includes active_daily)
          final user = loginResponse.user!;
          final hasActiveDaily = user.hasActiveDaily;

          if (!_isDisposed) {
            _safeSetState(
              AuthState.loaded(user: user, hasActiveDaily: hasActiveDaily),
            );
          }
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(AuthState.error(failure: ServerFailure(e.toString())));
      }
    }
  }

  /// Check authentication status and user profile
  /// Validates stored token and fetches user data
  Future<void> checkAuthStatus() async {
    if (_isDisposed) return;
    _safeSetState(const AuthState.loading());

    try {
      // Check if user has stored token
      final hasToken = await SecureStorageService.hasToken();
      if (_isDisposed) return;

      if (!hasToken) {
        _safeSetState(const AuthState.initial());
        return;
      }

      // Use GetProfileUseCase instead of direct API call
      final getProfileUseCase = ref.read(getProfileUseCaseProvider);
      final profileResult = await getProfileUseCase.execute();
      if (_isDisposed) return;

      await profileResult.fold(
        (failure) async {
          // Token invalid or error occurred, clear storage
          await SecureStorageService.clearAll();
          if (_isDisposed) return;
          _safeSetState(AuthState.error(failure: failure));
        },
        (user) async {
          // Use hasActiveDaily from user model (comes from profile API response)
          // The user profile already includes active_daily information
          final hasActiveDaily = user.hasActiveDaily;

          if (!_isDisposed) {
            _safeSetState(
              AuthState.loaded(user: user, hasActiveDaily: hasActiveDaily),
            );

            // Load app config after successful authentication
            // Config requires token, so we load it here after user is authenticated
            try {
              final configController = ref.read(configControllerProvider.notifier);
              await configController.loadConfig();
            } catch (e) {
              // Config loading failed, but don't block authentication
              // App will continue without config (graceful degradation)
            }
          }
        },
      );
    } catch (e) {
      // Error occurred, clear storage and reset state
      await SecureStorageService.clearAll();
      if (!_isDisposed) {
        _safeSetState(AuthState.error(failure: ServerFailure(e.toString())));
      }
    }
  }

  /// Logout user and clear all stored data
  /// Calls logout use case and clears local storage
  Future<void> logout() async {
    try {
      // Use Riverpod provider to get use case
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      final result = await logoutUseCase.execute();

      result.fold(
        (failure) {
          // Ignore logout errors, continue with local cleanup
        },
        (_) {
          // Logout successful
        },
      );
    } catch (e) {
      // Ignore logout errors, continue with local cleanup
    } finally {
      // Always clear local storage
      await SecureStorageService.clearAll();
      if (!_isDisposed) {
        _safeSetState(const AuthState.initial());
      }
    }
  }
}
