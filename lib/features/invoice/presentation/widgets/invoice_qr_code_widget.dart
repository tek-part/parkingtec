import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Invoice QR Code Widget
/// Displays QR code for invoice (if has_qr_code is true)
/// Handles both SVG format (from API) and plain text (for qr_flutter)
class InvoiceQrCodeWidget extends StatelessWidget {
  final Invoice invoice;

  const InvoiceQrCodeWidget({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    if (!invoice.hasQrCode || invoice.qrCode == null || invoice.qrCode!.isEmpty) {
      return const SizedBox.shrink();
    }

    final qrCodeData = invoice.qrCode!;

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
            S.of(context).qrCode,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: _buildQrCode(context, qrCodeData),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode(BuildContext context, String qrCodeData) {
    // Check if the data is SVG format
    if (qrCodeData.trim().startsWith('<?xml') || qrCodeData.trim().startsWith('<svg')) {
      // It's SVG, display it directly
      try {
        return SizedBox(
          width: 200.w,
          height: 200.w,
          child: SvgPicture.string(
            qrCodeData,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const CircularProgressIndicator(),
          ),
        );
      } catch (e) {
        // If SVG parsing fails, show error
        return Container(
          width: 200.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.error),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: AppColors.error, size: 32.w),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).invalidQrCode,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
    } else {
      // It's plain text, try to extract URL or use as-is
      // If it's a URL, we can try to display it as an image
      final uri = Uri.tryParse(qrCodeData);
      if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
        // It's a URL, try to load it as an image
        return SizedBox(
          width: 200.w,
          height: 200.w,
          child: Image.network(
            qrCodeData,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.error),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error, size: 32.w),
                      SizedBox(height: 8.h),
                      Text(
                        S.of(context).invalidQrCode,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        // It's plain text, but too long for qr_flutter
        // Show a message or try to extract invoice ID
        return Container(
          width: 200.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code, color: AppColors.primary, size: 48.w),
                SizedBox(height: 8.h),
                Text(
                  'Invoice ID: ${invoice.invoiceId}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary(context),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}

