import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/usecase_providers.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/presentation/states/config_state.dart';

/// Config controller (ViewModel)
/// Manages app config state and business logic
/// Uses StateNotifier for state management
class ConfigController extends StateNotifier<ConfigState> {
  final Ref ref;
  bool _isDisposed = false;

  ConfigController(this.ref) : super(const ConfigState.initial()) {
    // Keep alive during async operations
    ref.onDispose(() {
      _isDisposed = true;
    });
  }

  /// Safely update state only if not disposed
  void _safeSetState(ConfigState newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  /// Load app configuration from API
  /// Fetches app config and updates state
  Future<void> loadConfig() async {
    if (_isDisposed) return;
    _safeSetState(const ConfigState.loading());

    try {
      final getAppConfigUseCase = ref.read(getAppConfigUseCaseProvider);
      final result = await getAppConfigUseCase.execute();
      if (_isDisposed) return;

      result.fold(
        (failure) {
          _safeSetState(ConfigState.error(failure: failure));
        },
        (config) {
          _safeSetState(ConfigState.loaded(config));
        },
      );
    } catch (e) {
      if (!_isDisposed) {
        _safeSetState(
          ConfigState.error(failure: ServerFailure(e.toString())),
        );
      }
    }
  }
}

