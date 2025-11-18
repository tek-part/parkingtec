import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/auth/providers/auth_providers.dart';
import 'package:parkingtec/features/daily/providers/daily_providers.dart';
import 'package:parkingtec/features/daily/presentation/states/daily_state.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Logout Dialog with Daily Termination
/// Shows when user tries to logout while having active daily
class LogoutDialog extends ConsumerStatefulWidget {
  const LogoutDialog({super.key});

  @override
  ConsumerState<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends ConsumerState<LogoutDialog> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _endBalanceController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _endBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyState = ref.watch(dailyControllerProvider);
    final isLoading = dailyState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    // Listen to state changes for navigation and logout
    ref.listen<DailyState>(dailyControllerProvider, (previous, next) {
      next.maybeWhen(
        loaded: (daily, _) {
          // Success: terminate daily succeeded, now logout
          if (daily == null) {
            if (mounted) {
              // Logout user after successful termination
              ref.read(authControllerProvider.notifier).logout().then((_) {
                if (mounted) {
                  Navigator.pop(context); // Close dialog
                  context.go(Routes.login);
                }
              });
            }
          }
        },
        error: (failure) {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  failure.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        orElse: () {},
      );
    });

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(Icons.logout, color: AppColors.error, size: 24.w),
          SizedBox(width: 12.w),
          Text(
            S.of(context).logout,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).mustTerminateDailyBeforeLogout,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 20.h),

          // End Balance Field
          Text(
            S.of(context).endBalance,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _endBalanceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: S.of(context).enterEndBalance,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2.w),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Notes Field
          Text(
            S.of(context).notesOptional,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: S.of(context).enterAnyNotes,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary, width: 2.w),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 16.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _terminateDailyAndLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            disabledBackgroundColor: AppColors.error.withOpacity(0.5),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  S.of(context).terminateDailyAndLogout,
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

  /// Terminate daily and logout
  Future<void> _terminateDailyAndLogout() async {
    final endBalanceText = _endBalanceController.text.trim();
    if (endBalanceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).endBalanceRequired,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final endBalance = double.tryParse(endBalanceText);
    if (endBalance == null || endBalance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).invalidEndBalance,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final notes = _notesController.text.trim();

    // Use dailyControllerProvider to terminate daily
    // The ref.listen in build method will handle logout after success
    await ref
        .read(dailyControllerProvider.notifier)
        .terminateDaily(endBalance, notes.isEmpty ? null : notes);
  }
}
