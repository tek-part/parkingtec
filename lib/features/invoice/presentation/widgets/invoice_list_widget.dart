import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/presentation/widgets/invoice_card_widget.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice List Widget
/// Reusable widget for displaying a list of invoices
/// Supports both List and Grid layouts for tablets
class InvoiceListWidget extends ConsumerWidget {
  final List<Invoice> invoices;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoadRequested;
  final String emptyMessage;
  final bool isTablet;

  const InvoiceListWidget({
    super.key,
    required this.invoices,
    this.onRefresh,
    this.onLoadRequested,
    required this.emptyMessage,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (invoices.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      child: isTablet ? _buildGridView(context) : _buildListView(context),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        return InvoiceCardWidget(invoice: invoices[index]);
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.2,
      ),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        return InvoiceCardWidget(invoice: invoices[index]);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64.w,
              color: AppColors.textSecondary(context),
            ),
            SizedBox(height: 16.h),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
              textAlign: TextAlign.center,
            ),
            if (onLoadRequested != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onLoadRequested,
                icon: const Icon(Icons.refresh),
                label: Text(S.of(context).loadInvoices),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

