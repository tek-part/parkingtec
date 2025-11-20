import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/currency_formatter.dart';
import 'package:parkingtec/core/utils/invoice_timer.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Timer Widget
/// Displays timer countdown and changing price for hourly invoices
class InvoiceTimerWidget extends ConsumerStatefulWidget {
  final Invoice invoice;

  const InvoiceTimerWidget({
    super.key,
    required this.invoice,
  });

  @override
  ConsumerState<InvoiceTimerWidget> createState() => _InvoiceTimerWidgetState();
}

class _InvoiceTimerWidgetState extends ConsumerState<InvoiceTimerWidget> {
  Timer? _timer;
  Duration _currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateDuration();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _updateDuration();
        });
      }
    });
  }

  void _updateDuration() {
    _currentDuration = InvoiceTimer.calculateDuration(widget.invoice);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.invoice.isHourlyPricing || widget.invoice.isCompleted) {
      return const SizedBox.shrink();
    }

    final currency = ref.watch(currencyProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final showPrices = ref.watch(showPricesProvider);

    final hours = InvoiceTimer.calculateHours(_currentDuration);
    final currentAmount = widget.invoice.hourlyRate != null
        ? widget.invoice.hourlyRate! * hours
        : null;

    return RepaintBoundary(
      child: Container(
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
            S.of(context).timeElapsed,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Duration
              Text(
                InvoiceTimer.formatDuration(_currentDuration),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryX(context),
                    ),
              ),

              // Current Amount (if show_prices is enabled)
              if (showPrices && currentAmount != null)
                Text(
                  CurrencyFormatter.formatAmount(
                    currentAmount,
                    currency,
                    currencySymbol,
                  ),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryX(context),
                      ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${hours.toStringAsFixed(2)} ${S.of(context).hours}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary(context),
                ),
          ),
        ],
      ),
      ),
    );
  }
}

