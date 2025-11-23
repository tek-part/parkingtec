import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/invoice_timer.dart';
import 'package:parkingtec/core/widgets/qr_scanner_widget.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/complete_invoice_dialog.dart';
import 'package:parkingtec/features/invoice/providers/invoice_providers.dart';
import 'package:parkingtec/features/printing/presentation/widgets/dialogs/printer_not_connected_dialog.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import 'package:parkingtec/features/printing/utils/printer_connection_helper.dart';
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
              // Complete Invoice Button and QR Complete Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
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
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _completeWithQrAndPrint(context, ref),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(S.of(context).completeWithQr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryX(context),
                        foregroundColor: AppColors.background(context),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
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
                // Expanded(
                //   child: OutlinedButton.icon(
                //     onPressed: () => _reprintTicket(context, ref),
                //     icon: const Icon(Icons.print),
                //     label: Text(S.of(context).reprintTicket),
                //     style: OutlinedButton.styleFrom(
                //       foregroundColor: AppColors.primaryX(context),
                //       padding: EdgeInsets.symmetric(vertical: 12.h),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12.r),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(width: 8.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _reprintReceipt(context, ref),
                    icon: const Icon(Icons.receipt),
                    label: Text(
                      S.of(context).reprintReceipt,
                      textAlign: TextAlign.center,
                    ),
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.center,
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
    showDialog(
      context: context,
      builder: (context) => CompleteInvoiceDialog(invoice: invoice),
    );
    // if (requiresQrCode) {
    //   // Open QR scanner first
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => RepaintBoundary(
    //         child: QrScannerWidget(
    //           onScanSuccess: (scannedInvoiceId) {
    //             // Verify scanned invoice matches current invoice
    //             if (scannedInvoiceId != invoice.invoiceId) {
    //               Navigator.pop(context); // Close scanner
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text(
    //                     S.of(context).invalidQrCode,
    //                     style: const TextStyle(color: Colors.white),
    //                   ),
    //                   backgroundColor: AppColors.error,
    //                 ),
    //               );
    //               return;
    //             }

    //             // Close scanner and open complete dialog
    //             Navigator.pop(context);
    //             showDialog(
    //               context: context,
    //               builder: (context) => CompleteInvoiceDialog(invoice: invoice),
    //             );
    //           },
    //           onScanError: (error) {
    //             Navigator.pop(context); // Close scanner
    //             ScaffoldMessenger.of(context).showSnackBar(
    //               SnackBar(
    //                 content: Text(
    //                   error,
    //                   style: const TextStyle(color: Colors.white),
    //                 ),
    //                 backgroundColor: AppColors.error,
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //   );
    // } else {
    //   // No QR code required, open dialog directly
    //   showDialog(
    //     context: context,
    //     builder: (context) => CompleteInvoiceDialog(invoice: invoice),
    //   );
    // }
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

  /// Complete invoice with QR scan and print directly
  Future<void> _completeWithQrAndPrint(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // Open QR scanner
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepaintBoundary(
          child: QrScannerWidget(
            onScanSuccess: (scannedInvoiceId) async {
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

              // Close scanner
              Navigator.pop(context);

              // Calculate amount automatically
              double? calculatedAmount;
              if (invoice.isHourlyPricing) {
                calculatedAmount = InvoiceTimer.calculateCurrentAmountActual(
                  invoice,
                );
              } else if (invoice.isFixedPricing) {
                calculatedAmount = invoice.amount;
                if (calculatedAmount == null || calculatedAmount == 0) {
                  final defaultFixedPrice = ref.read(defaultFixedPriceProvider);
                  calculatedAmount = defaultFixedPrice;
                }
              }

              if (calculatedAmount == null || calculatedAmount <= 0) {
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

              // Check printer connection
              final isConnected = PrinterConnectionHelper.isPrinterConnected(
                ref,
              );
              if (!isConnected) {
                final result = await PrinterNotConnectedDialog.show(context);
                if (result == null || result == false) {
                  return; // User cancelled or navigated away
                }
              }

              // Complete invoice with calculated amount
              final request = CompleteInvoiceRequest(
                invoiceId: invoice.invoiceId,
                amount: calculatedAmount,
              );

              // Show loading dialog
              if (!context.mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => WillPopScope(
                  onWillPop: () async =>
                      false, // Prevent closing during loading
                  child: AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: 16.h),
                        Text(
                          S.of(context).completingInvoice,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );

              // Complete invoice (will auto-print if printer is connected)
              await ref
                  .read(completeInvoiceControllerProvider.notifier)
                  .completeInvoice(request, skipPrinting: !isConnected);

              // Wait for state to change to success or error
              // Poll the state until it's no longer loading
              bool isDialogClosed = false;
              while (context.mounted && !isDialogClosed) {
                final state = ref.read(completeInvoiceControllerProvider);
                final isComplete = state.maybeWhen(
                  success: (_) => true,
                  error: (_) => true,
                  orElse: () => false,
                );

                if (isComplete) {
                  // Wait for printing to complete if printer is connected
                  if (isConnected) {
                    // Give printing some time to complete
                    await Future.delayed(const Duration(milliseconds: 1500));
                  }

                  // Close loading dialog
                  if (context.mounted && !isDialogClosed) {
                    Navigator.of(context).pop();
                    isDialogClosed = true;
                  }

                  // Handle result
                  if (!context.mounted) return;

                  state.maybeWhen(
                    success: (completedInvoice) {
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
                              invoice.invoiceId,
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
                  break;
                }

                // Wait a bit before checking again
                await Future.delayed(const Duration(milliseconds: 100));
              }
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
  }
}
