import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/currency_formatter.dart';
import 'package:parkingtec/core/widgets/back_button_widget.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/presentation/states/invoice_state.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_actions_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_car_details_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_header_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_payment_status_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_qr_code_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_timer_widget.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Details Page
/// Displays detailed information about a specific invoice
class InvoiceDetailsPage extends ConsumerStatefulWidget {
  final int invoiceId;

  const InvoiceDetailsPage({
    super.key,
    required this.invoiceId,
  });

  @override
  ConsumerState<InvoiceDetailsPage> createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends ConsumerState<InvoiceDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Clear current invoice and load new one on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(invoiceControllerProvider.notifier);
      // Clear current invoice first to avoid showing old data
      controller.clearCurrentInvoice();
      // Then load the new invoice
      controller.loadInvoice(widget.invoiceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoiceState = ref.watch(invoiceControllerProvider);

    // Listen for errors
    ref.listen<InvoiceState>(invoiceControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                failure.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(
          S.of(context).invoiceDetails,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryX(context),
              ),
        ),
        backgroundColor: AppColors.background(context),
        elevation: 0,
      ),
      body: invoiceState.when(
        initial: () => _buildLoadingState(context),
        loading: () => _buildLoadingState(context),
        loaded: (_, __, ___, invoice, ____) {
          // Check if invoice matches the requested invoiceId
          if (invoice == null || invoice.invoiceId != widget.invoiceId) {
            return _buildLoadingState(context);
          }
          return _buildInvoiceDetails(context, invoice);
        },
        error: (failure) => _buildErrorState(context, failure.message),
      ),
    );
  }

  Widget _buildInvoiceDetails(BuildContext context, invoice) {
    final currency = ref.watch(currencyProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final showPrices = ref.watch(showPricesProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          InvoiceHeaderWidget(invoice: invoice),

          SizedBox(height: 16.h),

          // Timer (for hourly active invoices)
          if (invoice.isHourlyPricing && invoice.isActive)
            InvoiceTimerWidget(invoice: invoice),

          // Payment Status (for fixed invoices)
          if (invoice.isFixedPricing && invoice.isActive)
            InvoicePaymentStatusWidget(invoice: invoice),

          SizedBox(height: 16.h),

          // Car Details
          InvoiceCarDetailsWidget(invoice: invoice),

          SizedBox(height: 16.h),

          // Amount Information (if show_prices is enabled)
          if (showPrices && invoice.displayAmount != null) ...[
            Container(
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
                    S.of(context).finalAmount,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary(context),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    CurrencyFormatter.formatAmount(
                      invoice.displayAmount!,
                      currency,
                      currencySymbol,
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],

          // QR Code (if available)
          InvoiceQrCodeWidget(invoice: invoice),

          SizedBox(height: 16.h),

          // Actions
          InvoiceActionsWidget(invoice: invoice),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            S.of(context).loading,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary(context),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                ref.read(invoiceControllerProvider.notifier).loadInvoice(widget.invoiceId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}

