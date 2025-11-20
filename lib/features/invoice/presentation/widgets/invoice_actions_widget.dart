import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/widgets/qr_scanner_widget.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/complete_invoice_dialog.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import 'package:parkingtec/features/printing/usecases/reprint_invoice_usecase.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Actions Widget
/// Displays action buttons based on invoice type and status
class InvoiceActionsWidget extends ConsumerWidget {
  final Invoice invoice;

  const InvoiceActionsWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Action buttons for active/pending invoices
          if (!invoice.isCompleted) ...[
            if (invoice.isFixedPricing && !invoice.isPaid) ...[
              // Pay Invoice Button
              ElevatedButton.icon(
                onPressed: () => _showPayInvoiceDialog(context, ref),
                icon: const Icon(Icons.payment),
                label: Text(S.of(context).payInvoice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryX(context),
                  foregroundColor: AppColors.backgroundX(context),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ] else if (invoice.isHourlyPricing && invoice.isActive) ...[
              // Complete Invoice Button
              ElevatedButton.icon(
                onPressed: () => _showCompleteInvoiceDialog(context, ref),
                icon: const Icon(Icons.check_circle),
                label: Text(S.of(context).completeInvoice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ] else if (invoice.isPending) ...[
              // Pickup Invoice Button
              ElevatedButton.icon(
                onPressed: () => _showPickupInvoiceDialog(context, ref),
                icon: const Icon(Icons.local_shipping),
                label: Text(S.of(context).pickupInvoice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryX(context),
                  foregroundColor: AppColors.backgroundX(context),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ],

          // Reprint buttons for completed invoices
          if (invoice.isCompleted) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _reprintTicket(context, ref),
                    icon: const Icon(Icons.print),
                    label: Text(S.of(context).reprintTicket),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryX(context),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _reprintReceipt(context, ref),
                    icon: const Icon(Icons.receipt),
                    label: Text(S.of(context).reprintReceipt),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryX(context),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showPayInvoiceDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement pay invoice dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.of(context).payInvoice,
          style: TextStyle(color: AppColors.backgroundX(context)),
        ),
        backgroundColor: AppColors.primaryX(context),
      ),
    );
  }

  void _showCompleteInvoiceDialog(BuildContext context, WidgetRef ref) {
    // Check if QR code scanning is required
    final barcodeEnabled = ref.read(barcodeEnabledProvider);
    final requiresQrCode = barcodeEnabled && invoice.hasQrCode;

    if (requiresQrCode) {
      // Open QR scanner first
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RepaintBoundary(
            child: QrScannerWidget(
              onScanSuccess: (scannedInvoiceId) {
                // Verify scanned invoice matches current invoice
                if (scannedInvoiceId != invoice.invoiceId) {
                  Navigator.pop(context); // Close scanner
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.of(context).invalidQrCode,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                // Close scanner and open complete dialog
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => CompleteInvoiceDialog(invoice: invoice),
                );
              },
              onScanError: (error) {
                Navigator.pop(context); // Close scanner
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else {
      // No QR code required, open dialog directly
      showDialog(
        context: context,
        builder: (context) => CompleteInvoiceDialog(invoice: invoice),
      );
    }
  }

  void _showPickupInvoiceDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement pickup invoice dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.of(context).pickupInvoice,
          style: TextStyle(color: AppColors.backgroundX(context)),
        ),
        backgroundColor: AppColors.primaryX(context),
      ),
    );
  }

  /// Reprint entry ticket
  Future<void> _reprintTicket(BuildContext context, WidgetRef ref) async {
    try {
      final appConfig = ref.read(appConfigProvider);
      if (appConfig == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).configError,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final reprintUseCase = ref.read(reprintInvoiceUseCaseProvider);
      final result = await reprintUseCase(
        invoice,
        appConfig.toModel(),
        PrintJobType.entryTicket,
      );

      result.fold(
        (failure) {
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
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                S.of(context).invoicePrintedSuccess,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.success,
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${S.of(context).printError}: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Reprint exit receipt
  Future<void> _reprintReceipt(BuildContext context, WidgetRef ref) async {
    try {
      final appConfig = ref.read(appConfigProvider);
      if (appConfig == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).configError,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final reprintUseCase = ref.read(reprintInvoiceUseCaseProvider);
      final result = await reprintUseCase(
        invoice,
        appConfig.toModel(),
        PrintJobType.exitReceipt,
      );

      result.fold(
        (failure) {
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
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                S.of(context).invoicePrintedSuccess,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.success,
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${S.of(context).printError}: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
