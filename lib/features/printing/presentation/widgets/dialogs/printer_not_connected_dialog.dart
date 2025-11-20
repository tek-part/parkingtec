import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Printer Not Connected Dialog
/// Shows when user tries to print but printer is not connected
/// Returns:
/// - true: User chose to continue without printing
/// - false: User cancelled
/// - null: User navigated to settings
class PrinterNotConnectedDialog extends ConsumerWidget {
  const PrinterNotConnectedDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PrinterNotConnectedDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = S.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.print_disabled,
            color: AppColors.error,
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              s.printerNotConnected,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
      content: Text(
        s.printerNotConnectedMessage,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary(context),
            ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            s.cancel,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 16.sp,
            ),
          ),
        ),
        // Continue without printing button
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            s.continueWithoutPrinting,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Go to Settings button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(null); // Return null to indicate navigation
            // Navigate to settings with printer tab (index 0)
            context.push(
              Routes.settings,
              extra: {'initialTab': 0},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            s.goToSettings,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

