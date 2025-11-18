import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/daily/providers/daily_providers.dart';
import 'package:parkingtec/features/daily/presentation/states/daily_state.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Confirm Terminate Daily Dialog
/// Shows a confirmation dialog before ending the daily session
class ConfirmTerminateDailyDialog extends ConsumerStatefulWidget {
  final double endBalance;
  final String? notes;

  const ConfirmTerminateDailyDialog({
    super.key,
    required this.endBalance,
    this.notes,
  });

  @override
  ConsumerState<ConfirmTerminateDailyDialog> createState() =>
      _ConfirmTerminateDailyDialogState();
}

class _ConfirmTerminateDailyDialogState
    extends ConsumerState<ConfirmTerminateDailyDialog> {
  Future<void> _handleConfirm() async {
    await ref
        .read(dailyControllerProvider.notifier)
        .terminateDaily(widget.endBalance, widget.notes);
  }

  @override
  Widget build(BuildContext context) {
    final dailyState = ref.watch(dailyControllerProvider);
    final isLoading = dailyState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    // Listen to state changes for navigation and error handling
    ref.listen<DailyState>(dailyControllerProvider, (previous, next) {
      next.maybeWhen(
        loaded: (daily, _) {
          // Success: navigate to start daily page
          if (daily == null) {
            if (mounted) {
              Navigator.of(context).pop(); // Close dialog
              context.go(Routes.dailyStart);
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              S.of(context).confirmEndSession,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).endSessionConfirmationMessage(
                  widget.endBalance.toStringAsFixed(2),
                ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary(context),
                ),
          ),
          if (widget.notes != null && widget.notes!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              '${S.of(context).notes}: ${widget.notes}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 16.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _handleConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            disabledBackgroundColor: AppColors.error.withOpacity(0.5),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  S.of(context).confirm,
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

