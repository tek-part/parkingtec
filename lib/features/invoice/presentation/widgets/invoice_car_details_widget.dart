import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice Car Details Widget
/// Displays car information and timestamps
class InvoiceCarDetailsWidget extends StatelessWidget {
  final Invoice invoice;

  const InvoiceCarDetailsWidget({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
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
            S.of(context).carNumber,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8.h),
          _buildDetailRow(
            context,
            icon: Icons.directions_car,
            label: invoice.carNum,
          ),

          if (invoice.carModel != null && invoice.carModel!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              S.of(context).carModel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.h),
            _buildDetailRow(
              context,
              icon: Icons.info_outline,
              label: invoice.carModel!,
            ),
          ],

          SizedBox(height: 12.h),
          Text(
            S.of(context).startTime,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8.h),
          _buildDetailRow(
            context,
            icon: Icons.access_time,
            label: _formatDateTime(invoice.startTime),
          ),

          if (invoice.endTime != null) ...[
            SizedBox(height: 12.h),
            Text(
              S.of(context).endTime,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.h),
            _buildDetailRow(
              context,
              icon: Icons.access_time_filled,
              label: _formatDateTime(invoice.endTime!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.w,
          color: AppColors.textSecondary(context),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary(context),
                ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}

