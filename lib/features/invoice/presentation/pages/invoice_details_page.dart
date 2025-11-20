import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/currency_formatter.dart';
import 'package:parkingtec/core/widgets/back_button_widget.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/presentation/states/invoice_details_state.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_actions_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_car_details_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_header_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_payment_status_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_qr_code_widget.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_timer_widget.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';
import 'package:parkingtec/features/printing/presentation/widgets/dialogs/printer_not_connected_dialog.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import 'package:parkingtec/features/printing/utils/printer_connection_helper.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Details Page
/// Displays detailed information about a specific invoice
class InvoiceDetailsPage extends ConsumerStatefulWidget {
  final int invoiceId;

  const InvoiceDetailsPage({super.key, required this.invoiceId});

  @override
  ConsumerState<InvoiceDetailsPage> createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends ConsumerState<InvoiceDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Load invoice on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(invoiceDetailsControllerProvider(widget.invoiceId).notifier)
          .loadInvoice();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoiceDetailsState = ref.watch(
      invoiceDetailsControllerProvider(widget.invoiceId),
    );

    // Listen for errors
    ref.listen<InvoiceDetailsState>(
      invoiceDetailsControllerProvider(widget.invoiceId),
      (previous, next) {
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
      },
    );

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
        actions: [
          // Print button
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _handlePrintInvoice(context, invoiceDetailsState),
            tooltip: S.of(context).printInvoice,
          ),
        ],
      ),
      body: invoiceDetailsState.when(
        initial: () => _buildLoadingState(context),
        loading: () => _buildLoadingState(context),
        loaded: (invoice) => _buildInvoiceDetails(context, invoice),
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
                border: Border.all(color: AppColors.border(context), width: 1),
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
                      color: AppColors.textPrimary(context),
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
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryX(context),
            ),
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
            Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              errorMessage,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(
                      invoiceDetailsControllerProvider(
                        widget.invoiceId,
                      ).notifier,
                    )
                    .loadInvoice();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryX(context),
                foregroundColor: AppColors.background(context),
              ),
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle print invoice action
  Future<void> _handlePrintInvoice(
    BuildContext context,
    InvoiceDetailsState state,
  ) async {
    // Check if invoice is loaded
    final invoice = state.maybeWhen(loaded: (inv) => inv, orElse: () => null);

    if (invoice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).loading),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Check printer connection
    final isConnected = PrinterConnectionHelper.isPrinterConnected(ref);

    if (!isConnected) {
      // Show dialog
      await PrinterNotConnectedDialog.show(context);
      // If user chose to continue without printing, do nothing (no print action)
      // If user navigated to settings, do nothing
      // If user cancelled, do nothing
      return;
    }

    // Printer is connected, proceed with printing
    try {
      final appConfig = ref.read(appConfigProvider);
      if (appConfig == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).configError),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final printUseCase = ref.read(printInvoiceUseCaseProvider);
      final printResult = await printUseCase.printEntryTicket(
        invoice,
        appConfig.toModel(),
      );

      if (mounted) {
        printResult.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: AppColors.error,
              ),
            );
          },
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).invoicePrintedSuccess),
                backgroundColor: AppColors.success,
              ),
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).printError}: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
