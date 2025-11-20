import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/printing/presentation/pages/printer_settings_page.dart';

/// Printer Settings Tab
/// Simple wrapper that navigates to printer settings page
class PrinterSettingsTab extends ConsumerWidget {
  const PrinterSettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PrinterSettingsPage();
  }
}
