import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/invoice_timer.dart';
import 'package:parkingtec/core/widgets/form_fields.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/presentation/states/complete_invoice_state.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';
import 'package:parkingtec/features/printing/presentation/widgets/dialogs/printer_not_connected_dialog.dart';
import 'package:parkingtec/features/printing/utils/printer_connection_helper.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Complete Invoice Dialog
/// Dialog for completing an invoice
/// If QR code is enabled, requires QR scan first
class CompleteInvoiceDialog extends ConsumerStatefulWidget {
  final Invoice invoice;

  const CompleteInvoiceDialog({super.key, required this.invoice});

  @override
  ConsumerState<CompleteInvoiceDialog> createState() =>
      _CompleteInvoiceDialogState();
}

class _CompleteInvoiceDialogState extends ConsumerState<CompleteInvoiceDialog> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Calculate and pre-fill amount automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateAndSetAmount();
    });
  }

  void _calculateAndSetAmount() {
    double? calculatedAmount;

    if (widget.invoice.isHourlyPricing) {
      // For hourly pricing: calculate from hourlyRate × hours
      calculatedAmount = InvoiceTimer.calculateCurrentAmount(widget.invoice);
    } else if (widget.invoice.isFixedPricing) {
      // For fixed pricing: use amount or defaultFixedPrice
      calculatedAmount = widget.invoice.amount;
      if (calculatedAmount == null || calculatedAmount == 0) {
        // Get default fixed price from config
        final defaultFixedPrice = ref.read(defaultFixedPriceProvider);
        calculatedAmount = defaultFixedPrice;
      }
    }

    // Set calculated amount in controller
    if (calculatedAmount != null && calculatedAmount > 0) {
      _amountController.text = calculatedAmount.toStringAsFixed(2);
    } else if (widget.invoice.displayAmount != null) {
      // Fallback to displayAmount if calculation fails
      _amountController.text = widget.invoice.displayAmount!.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    if (_isLoading) return;

    // Validate amount
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).amountRequired,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).invalidAmount,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check printer connection before completing invoice
    final isConnected = PrinterConnectionHelper.isPrinterConnected(ref);

    if (!isConnected) {
      // Show printer not connected dialog
      if (!mounted) return;
      final result = await PrinterNotConnectedDialog.show(context);

      if (!mounted) return;
      if (result == null) {
        // User navigated to settings, cancel completion
        return;
      } else if (result == false) {
        // User cancelled, do nothing
        return;
      }
      // result == true: User chose to continue without printing
      // Proceed with completion (printing will be skipped in controller)
    }

    setState(() => _isLoading = true);

    final request = CompleteInvoiceRequest(
      invoiceId: widget.invoice.invoiceId,
      amount: amount,
    );

    // Pass skipPrinting flag if printer is not connected
    await ref
        .read(completeInvoiceControllerProvider.notifier)
        .completeInvoice(
          request,
          skipPrinting: !isConnected,
        );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final completeInvoiceState = ref.watch(completeInvoiceControllerProvider);
    final isLoading =
        completeInvoiceState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ) ||
        _isLoading;

    // Listen for success
    ref.listen<CompleteInvoiceState>(completeInvoiceControllerProvider, (
      previous,
      next,
    ) {
      next.maybeWhen(
        success: (invoice) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                S.of(context).invoiceCompleted,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.success,
            ),
          );
          // Refresh invoice details
          ref
              .read(
                invoiceDetailsControllerProvider(
                  widget.invoice.invoiceId,
                ).notifier,
              )
              .loadInvoice();
        },
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

    // Check if QR code is required
    final barcodeEnabled = ref.watch(barcodeEnabledProvider);
    final requiresQrCode = barcodeEnabled && widget.invoice.hasQrCode;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              S.of(context).completeInvoice,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.success,
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
          if (requiresQrCode) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.warning,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      S.of(context).qrCodeRequired,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
          AmountField(
            controller: _amountController,
            label: S.of(context).finalAmount,
            icon: Icons.attach_money,
          ),
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
          onPressed: isLoading ? null : _handleComplete,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            disabledBackgroundColor: AppColors.success.withOpacity(0.5),
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
                  S.of(context).completeInvoice,
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
