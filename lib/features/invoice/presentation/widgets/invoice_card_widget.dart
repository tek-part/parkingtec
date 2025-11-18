import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/currency_formatter.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Card Widget
/// Reusable widget for displaying a single invoice in a list
class InvoiceCardWidget extends ConsumerWidget {
  final Invoice invoice;

  const InvoiceCardWidget({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 20.w : 16.w;
        final spacing = isTablet ? 12.h : 8.h;

        return InkWell(
          onTap: () => context.push(Routes.invoiceDetails(invoice.invoiceId)),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(padding),
            margin: EdgeInsets.only(bottom: isTablet ? 16.h : 12.h),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: Car Number and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        invoice.carNum,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                              fontSize: isTablet ? 18.sp : null,
                            ),
                      ),
                    ),
                    _buildStatusBadge(context, isTablet),
                  ],
                ),

                SizedBox(height: spacing),

                // Customer Name (if available)
                if (invoice.customerName != null && invoice.customerName!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: isTablet ? 6.h : 4.h),
                    child: Text(
                      invoice.customerName!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary(context),
                            fontSize: isTablet ? 16.sp : null,
                          ),
                    ),
                  ),

                // Car Model (if available)
                if (invoice.carModel != null && invoice.carModel!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: isTablet ? 10.h : 8.h),
                    child: Text(
                      invoice.carModel!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary(context),
                            fontSize: isTablet ? 14.sp : null,
                          ),
                    ),
                  ),

                SizedBox(height: spacing),

                // Details Row: Time and Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Start Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: isTablet ? 20.w : 16.w,
                          color: AppColors.textSecondary(context),
                        ),
                        SizedBox(width: isTablet ? 6.w : 4.w),
                        Text(
                          _formatTime(invoice.startTime),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary(context),
                                fontSize: isTablet ? 14.sp : null,
                              ),
                        ),
                      ],
                    ),

                    // Amount (if show_prices is enabled)
                    if (ref.watch(showPricesProvider) && invoice.displayAmount != null)
                      Text(
                        CurrencyFormatter.formatAmount(
                          invoice.displayAmount!,
                          currency,
                          currencySymbol,
                        ),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: isTablet ? 18.sp : null,
                            ),
                      ),
                  ],
                ),

                // Duration for hourly pricing
                if (invoice.isHourlyPricing && invoice.durationHours > 0) ...[
                  SizedBox(height: isTablet ? 6.h : 4.h),
                  Text(
                    '${invoice.durationHours.toStringAsFixed(2)} ${S.of(context).hours}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary(context),
                          fontSize: isTablet ? 14.sp : null,
                        ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isTablet) {
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
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12.w : 8.w,
        vertical: isTablet ? 6.h : 4.h,
      ),
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
              fontSize: isTablet ? 12.sp : 10.sp,
            ),
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      final dateTime = DateTime.parse(timeString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return timeString;
    }
  }
}

