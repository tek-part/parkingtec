import 'package:flutter/material.dart';

/// ===== DARK PALETTE (Primary = Dark Gray + Black) =====
class DarkColors {
  static const Color primary = Color(0xFF1A1D23); // dark gray
  static const Color primaryDark = Color(0xFF0B0D12); // near black
  static const Color primaryLight = Color(0xFF232833); // hover/pressed

  static const Color background = Color(0xFF0B0D12);
  static const Color surface = Color(0xFF12161E);
  static const Color card = Color(0xFF171C27);
  static const Color border = Color(0xFF2A2F3A);

  static const Color textPrimary = Color(0xFFE6E9EF);
  static const Color textSecondary = Color(0xFFB0B7C3);
  static const Color muted = Color(0xFF8A93A3);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

/// ===== LIGHT PALETTE (Premium Light with Dark Gray accents) =====
class LightColors {
  static const Color primary = Color(0xFF1A1D23); // keep brand dark gray
  static const Color primaryDark = Color(0xFF0F1217);
  static const Color primaryLight = Color(0xFF2A2F39);

  static const Color background = Color(0xFFF6F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E7EC);

  static const Color textPrimary = Color(0xFF0E1116);
  static const Color textSecondary = Color(0xFF3D4451);
  static const Color muted = Color(0xFF6B7280);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
}

class AppColors {
  // isLight
  static bool isLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  // Primary Colors - Work for both light and dark
  static const Color primary = Color(0xFF1A1D23);
  static const Color primaryDark = Color.fromARGB(255, 217, 222, 235);
  static const Color primaryLight = Color(0xFF0B0D12);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF0B0D12);
  static const Color surfaceDark = Color(0xFF12161E);
  static const Color cardDark = Color(0xFF171C27);
  static const Color borderDark = Color(0xFF2A2F3A);
  static const Color textPrimaryDark = Color(0xFFE6E9EF);
  static const Color textSecondaryDark = Color(0xFFB0B7C3);
  static const Color mutedDark = Color(0xFF8A93A3);

  // Light Mode Colors
  static const Color backgroundLight = Color(0xFFF6F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE4E7EC);
  static const Color textPrimaryLight = Color(0xFF0E1116);
  static const Color textSecondaryLight = Color(0xFF3D4451);
  static const Color mutedLight = Color(0xFF6B7280);

  // Status Colors - Work for both modes
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color scrim = Color(0xE6070A0F);

  // Helper methods for theme-aware colors
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }

  static Color backgroundX(BuildContext context) {
    return Theme.of(context).brightness != Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? surfaceDark
        : surfaceLight;
  }

  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardDark
        : cardLight;
  }

  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? borderDark
        : borderLight;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textPrimaryDark
        : textPrimaryLight;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textSecondaryDark
        : textSecondaryLight;
  }

  static Color muted(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? mutedDark
        : mutedLight;
  }

  static Color primaryX(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? primaryDark
        : primaryLight;
  }
}
