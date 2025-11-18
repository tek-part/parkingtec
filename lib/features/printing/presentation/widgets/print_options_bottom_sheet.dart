import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

class PrintOptionsBottomSheet extends ConsumerWidget {
  final String content;
  final String type;

  const PrintOptionsBottomSheet({
    super.key,
    required this.content,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(printingLoadingProvider);
    final error = ref.watch(printingErrorProvider);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border(context),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Title
          Text(
            S.of(context).printOptions,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 16.h),

          // Content Preview
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary(context),
                fontFamily: 'monospace',
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Error Message
          if (error != null)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.error),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: AppColors.error, size: 20.w),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      error,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),

          // Print Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : () => _handlePrint(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.print),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).print,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePrint(BuildContext context, WidgetRef ref) async {
    if (type == 'receipt') {
      await ref
          .read(printingNotifierProvider.notifier)
          .printReceipt(content: content, type: type);
    } else {
      await ref
          .read(printingNotifierProvider.notifier)
          .printInvoice(content: content, type: type);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
