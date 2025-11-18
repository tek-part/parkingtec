import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/currency_formatter.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Payment Status Widget
/// Displays payment status for fixed pricing invoices
class InvoicePaymentStatusWidget extends ConsumerWidget {
  final Invoice invoice;

  const InvoicePaymentStatusWidget({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!invoice.isFixedPricing || invoice.isCompleted) {
      return const SizedBox.shrink();
    }

    final currency = ref.watch(currencyProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final showPrices = ref.watch(showPricesProvider);
    final defaultFixedPrice = ref.watch(defaultFixedPriceProvider);

    final isPaid = invoice.isPaid;
    final requiredAmount = defaultFixedPrice ?? invoice.amount ?? 0.0;

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
          Text(
            S.of(context).invoiceStatus,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Payment Status
              Row(
                children: [
                  Icon(
                    isPaid ? Icons.check_circle : Icons.cancel,
                    color: isPaid ? AppColors.success : AppColors.error,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isPaid ? S.of(context).paid : S.of(context).unpaid,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPaid ? AppColors.success : AppColors.error,
                        ),
                  ),
                ],
              ),

              // Required Amount (if show_prices is enabled)
              if (showPrices)
                Text(
                  CurrencyFormatter.formatAmount(
                    requiredAmount,
                    currency,
                    currencySymbol,
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

