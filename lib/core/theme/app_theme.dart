import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: DarkColors.primary,
      onPrimary: DarkColors.textPrimary,
      secondary: DarkColors.primaryLight,
      onSecondary: DarkColors.textPrimary,
      error: DarkColors.error,
      onError: Colors.white,
      surface: DarkColors.surface,
      onSurface: DarkColors.textSecondary,
    );

    final TextTheme baseText = const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Cairo'),
      displayMedium: TextStyle(fontFamily: 'Cairo'),
      displaySmall: TextStyle(fontFamily: 'Cairo'),
      headlineLarge: TextStyle(fontFamily: 'Cairo'),
      headlineMedium: TextStyle(fontFamily: 'Cairo'),
      headlineSmall: TextStyle(fontFamily: 'Cairo'),
      titleLarge: TextStyle(fontFamily: 'Cairo'),
      titleMedium: TextStyle(fontFamily: 'Cairo'),
      titleSmall: TextStyle(fontFamily: 'Cairo'),
      bodyLarge: TextStyle(fontFamily: 'Cairo'),
      bodyMedium: TextStyle(fontFamily: 'Cairo'),
      bodySmall: TextStyle(fontFamily: 'Cairo'),
      labelLarge: TextStyle(fontFamily: 'Cairo'),
      labelMedium: TextStyle(fontFamily: 'Cairo'),
      labelSmall: TextStyle(fontFamily: 'Cairo'),
    ).apply(
      bodyColor: DarkColors.textPrimary,
      displayColor: DarkColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: DarkColors.background,
      canvasColor: DarkColors.surface,
      cardColor: DarkColors.card,
      dividerColor: DarkColors.border,
      textTheme: baseText.copyWith(
        bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: baseText.bodyMedium?.copyWith(
          fontSize: 14,
          color: DarkColors.textSecondary,
        ),
        titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        headlineSmall: baseText.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: DarkColors.surface,
        foregroundColor: DarkColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(DarkColors.primary),
          foregroundColor: WidgetStatePropertyAll(DarkColors.textPrimary),
          overlayColor: WidgetStateProperty.resolveWith((s) {
            if (s.contains(WidgetState.pressed)) return DarkColors.primaryDark;
            if (s.contains(WidgetState.hovered)) return DarkColors.primaryLight;
            return null;
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(DarkColors.textPrimary),
          side: WidgetStatePropertyAll(BorderSide(color: DarkColors.border)),
          overlayColor: WidgetStatePropertyAll(
            DarkColors.primary.withValues(alpha: 0.10),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(DarkColors.textPrimary),
          overlayColor: WidgetStatePropertyAll(
            DarkColors.primary.withValues(alpha: 0.12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkColors.card,
        hintStyle: const TextStyle(color: DarkColors.muted),
        labelStyle: const TextStyle(color: DarkColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: DarkColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: DarkColors.primaryLight,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: DarkColors.error),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: DarkColors.surface,
        selectedColor: DarkColors.primaryLight.withValues(alpha: 0.25),
        labelStyle: const TextStyle(color: DarkColors.textSecondary),
        side: const BorderSide(color: DarkColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: DarkColors.card,
        contentTextStyle: TextStyle(color: DarkColors.textSecondary),
        behavior: SnackBarBehavior.floating,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DarkColors.primary,
        foregroundColor: DarkColors.textPrimary,
        elevation: 2,
      ),

      cardTheme: CardThemeData(
        color: DarkColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: DarkColors.border),
        ),
        margin: const EdgeInsets.all(12),
      ),

      dividerTheme: const DividerThemeData(
        color: DarkColors.border,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: DarkColors.textPrimary),
    );
  }

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: LightColors.primary,
      onPrimary: Colors.white, // white text on dark-gray button
      secondary: LightColors.primaryLight,
      onSecondary: Colors.white,
      error: LightColors.error,
      onError: Colors.white,
      surface: LightColors.surface,
      onSurface: LightColors.textSecondary,
    );

    final TextTheme baseText = const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Cairo'),
      displayMedium: TextStyle(fontFamily: 'Cairo'),
      displaySmall: TextStyle(fontFamily: 'Cairo'),
      headlineLarge: TextStyle(fontFamily: 'Cairo'),
      headlineMedium: TextStyle(fontFamily: 'Cairo'),
      headlineSmall: TextStyle(fontFamily: 'Cairo'),
      titleLarge: TextStyle(fontFamily: 'Cairo'),
      titleMedium: TextStyle(fontFamily: 'Cairo'),
      titleSmall: TextStyle(fontFamily: 'Cairo'),
      bodyLarge: TextStyle(fontFamily: 'Cairo'),
      bodyMedium: TextStyle(fontFamily: 'Cairo'),
      bodySmall: TextStyle(fontFamily: 'Cairo'),
      labelLarge: TextStyle(fontFamily: 'Cairo'),
      labelMedium: TextStyle(fontFamily: 'Cairo'),
      labelSmall: TextStyle(fontFamily: 'Cairo'),
    ).apply(
      bodyColor: LightColors.textPrimary,
      displayColor: LightColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: LightColors.background,
      canvasColor: LightColors.surface,
      cardColor: LightColors.card,
      dividerColor: LightColors.border,
      textTheme: baseText.copyWith(
        bodyLarge: baseText.bodyLarge?.copyWith(fontSize: 16),
        bodyMedium: baseText.bodyMedium?.copyWith(
          fontSize: 14,
          color: LightColors.textSecondary,
        ),
        titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        headlineSmall: baseText.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: LightColors.surface,
        foregroundColor: LightColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(LightColors.primary),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStateProperty.resolveWith((s) {
            if (s.contains(WidgetState.pressed)) return LightColors.primaryDark;
            if (s.contains(WidgetState.hovered)) {
              return LightColors.primaryLight;
            }
            return null;
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(LightColors.textPrimary),
          side: WidgetStatePropertyAll(BorderSide(color: LightColors.border)),
          overlayColor: WidgetStatePropertyAll(
            LightColors.primary.withValues(alpha: 0.08),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(LightColors.primary),
          overlayColor: WidgetStatePropertyAll(
            LightColors.primary.withValues(alpha: 0.10),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: LightColors.muted),
        labelStyle: const TextStyle(color: LightColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: LightColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: LightColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: LightColors.error),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: LightColors.primary.withValues(alpha: 0.08),
        labelStyle: const TextStyle(color: LightColors.textSecondary),
        side: const BorderSide(color: LightColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: TextStyle(color: LightColors.textPrimary),
        behavior: SnackBarBehavior.floating,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: LightColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),

      cardTheme: CardThemeData(
        color: LightColors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: LightColors.border),
        ),
        margin: const EdgeInsets.all(12),
      ),

      dividerTheme: const DividerThemeData(
        color: LightColors.border,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: LightColors.textPrimary),
    );
  }
}
