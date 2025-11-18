import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/auth/providers/auth_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Simple Logout Dialog
/// Shows when user wants to logout without active daily
class SimpleLogoutDialog extends ConsumerWidget {
  const SimpleLogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(Icons.logout, color: AppColors.error, size: 24.w),
          SizedBox(width: 12.w),
          Text(
            S.of(context).simpleLogout,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        S.of(context).areYouSureLogout,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary(context),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 16.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // Logout user
            await ref.read(authControllerProvider.notifier).logout();
            
            if (context.mounted) {
              Navigator.pop(context);
              context.go(Routes.login);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            S.of(context).simpleLogout,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

