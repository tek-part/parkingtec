import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/core/storage/preferences_storage.dart';

/// Theme Notifier
/// Manages theme mode state and persists it to SharedPreferences
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  /// Load theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final savedTheme = await PreferencesStorage.getThemeMode();
      if (savedTheme != null) {
        // Convert string to ThemeMode enum
        final themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == savedTheme,
          orElse: () => ThemeMode.dark,
        );
        state = themeMode;
      }
    } catch (e) {
      // If error occurs, use default value
      state = ThemeMode.dark;
    }
  }

  /// Set theme mode and save to SharedPreferences
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      await PreferencesStorage.saveThemeMode(mode.name);
    } catch (e) {
      // If save fails, state is already updated
      // Could add error handling/logging here if needed
    }
  }
}

/// Language Notifier
/// Manages language state and persists it to SharedPreferences
class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('ar') {
    _loadLanguage();
  }

  /// Load language code from SharedPreferences
  Future<void> _loadLanguage() async {
    try {
      final savedLanguage = await PreferencesStorage.getLanguageCode();
      if (savedLanguage != null && savedLanguage.isNotEmpty) {
        state = savedLanguage;
      }
    } catch (e) {
      // If error occurs, use default value
      state = 'ar';
    }
  }

  /// Set language code and save to SharedPreferences
  Future<void> setLanguage(String language) async {
    state = language;
    try {
      await PreferencesStorage.saveLanguageCode(language);
    } catch (e) {
      // If save fails, state is already updated
      // Could add error handling/logging here if needed
    }
  }
}

/// Theme Notifier Provider
/// Provides theme mode state management
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

/// Language Notifier Provider
/// Provides language state management
final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, String>(
      (ref) => LanguageNotifier(),
    );
