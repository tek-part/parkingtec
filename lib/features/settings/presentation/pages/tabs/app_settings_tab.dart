import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/di/providers/app_settings_providers.dart';
import '../../widgets/theme_selector.dart';
import '../../widgets/language_selector.dart';

class AppSettingsTab extends ConsumerWidget {
  const AppSettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemeSelector(
            currentTheme: ref.watch(themeNotifierProvider),
            onThemeChanged: (theme) {
              ref.read(themeNotifierProvider.notifier).setThemeMode(theme);
            },
          ),
          SizedBox(height: 24.h),
          LanguageSelector(
            currentLanguage: ref.watch(languageNotifierProvider),
            onLanguageChanged: (language) {
              ref.read(languageNotifierProvider.notifier).setLanguage(language);
            },
          ),
        ],
      ),
    );
  }
}

