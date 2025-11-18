import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/complete_invoice_dialog.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Actions Widget
/// Displays action buttons based on invoice type and status
class InvoiceActionsWidget extends ConsumerWidget {
  final Invoice invoice;

  const InvoiceActionsWidget({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // No actions for completed invoices
    if (invoice.isCompleted) {
      return const SizedBox.shrink();
    }

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (invoice.isFixedPricing && !invoice.isPaid) ...[
            // Pay Invoice Button
            ElevatedButton.icon(
              onPressed: () => _showPayInvoiceDialog(context, ref),
              icon: const Icon(Icons.payment),
              label: Text(S.of(context).payInvoice),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
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
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showCompleteInvoiceDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => CompleteInvoiceDialog(invoice: invoice),
    );
  }

  void _showPickupInvoiceDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement pickup invoice dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.of(context).pickupInvoice,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

