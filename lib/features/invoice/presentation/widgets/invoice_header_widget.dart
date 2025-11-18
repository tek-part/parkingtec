import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Header Widget
/// Displays basic invoice information (ID, status, etc.)
class InvoiceHeaderWidget extends ConsumerWidget {
  final Invoice invoice;

  const InvoiceHeaderWidget({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.border(context),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${S.of(context).invoiceId}: #${invoice.invoiceId}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
              ),
              _buildStatusBadge(context),
            ],
          ),

          SizedBox(height: 12.h),

          // Car Number
          Text(
            invoice.carNum,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.w600,
                ),
          ),

          // Customer Name (if available)
          if (invoice.customerName != null && invoice.customerName!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              invoice.customerName!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
            ),
          ],

          // Car Model (if available)
          if (invoice.carModel != null && invoice.carModel!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              invoice.carModel!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color badgeColor;
    String statusText;

    if (invoice.isPending) {
      badgeColor = AppColors.warning;
      statusText = S.of(context).pending;
    } else if (invoice.isCompleted) {
      badgeColor = AppColors.success;
      statusText = S.of(context).completed;
    } else {
      badgeColor = AppColors.primary;
      statusText = S.of(context).active;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
      ),
    );
  }
}

