import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/features/auth/data/models/session.dart';

// Session State
class SessionState {
  final bool isLoading;
  final List<Session> sessions;
  final Session? activeSession;
  final String? error;

  const SessionState({
    this.isLoading = false,
    this.sessions = const [],
    this.activeSession,
    this.error,
  });

  SessionState copyWith({
    bool? isLoading,
    List<Session>? sessions,
    Session? activeSession,
    String? error,
  }) {
    return SessionState(
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
      activeSession: activeSession ?? this.activeSession,
      error: error ?? this.error,
    );
  }
}

// Session Notifier
class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  Future<void> loadSessions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Load sessions from API
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false, sessions: []);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createSession(String lotId, String vehiclePlate) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Create session via API
      await Future.delayed(const Duration(seconds: 1));

      final session = Session(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: 0,
        startBalance: 0.0,
        startTime: DateTime.now().toIso8601String(),
        status: 'active',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      state = state.copyWith(isLoading: false, activeSession: session);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> endSession(String sessionId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: End session via API
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false, activeSession: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final sessionNotifierProvider =
    StateNotifierProvider<SessionNotifier, SessionState>(
      (ref) => SessionNotifier(),
    );

final sessionsProvider = Provider<List<Session>>((ref) {
  return ref.watch(sessionNotifierProvider).sessions;
});

final activeSessionProvider = Provider<Session?>((ref) {
  return ref.watch(sessionNotifierProvider).activeSession;
});

final sessionLoadingProvider = Provider<bool>((ref) {
  return ref.watch(sessionNotifierProvider).isLoading;
});

final sessionErrorProvider = Provider<String?>((ref) {
  return ref.watch(sessionNotifierProvider).error;
});
