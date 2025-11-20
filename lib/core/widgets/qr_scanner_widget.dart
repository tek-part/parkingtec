import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/widgets/back_button_widget.dart';
import 'package:parkingtec/generated/l10n.dart';

/// QR Scanner Widget
/// Reusable widget for scanning QR codes
/// Extracts invoice_id from QR code URL format: https://domain.com/p/{invoice_id}
class QrScannerWidget extends ConsumerStatefulWidget {
  final Function(int invoiceId) onScanSuccess;
  final Function(String error) onScanError;

  const QrScannerWidget({
    super.key,
    required this.onScanSuccess,
    required this.onScanError,
  });

  @override
  ConsumerState<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends ConsumerState<QrScannerWidget> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Extract invoice ID from QR code URL
  /// Supports multiple formats:
  /// - https://domain.com/p/{invoice_id}
  /// - https://domain.com/invoice/{invoice_id}
  /// - https://domain.com/{invoice_id} (last segment)
  int? _extractInvoiceId(String qrCode) {
    try {
      final uri = Uri.parse(qrCode);
      final segments = uri.pathSegments;

      // Look for 'p' segment followed by invoice ID
      for (int i = 0; i < segments.length; i++) {
        if (segments[i] == 'p' && i + 1 < segments.length) {
          final invoiceId = int.tryParse(segments[i + 1]);
          if (invoiceId != null && invoiceId > 0) {
            return invoiceId;
          }
        }
      }

      // Look for 'invoice' segment followed by invoice ID
      for (int i = 0; i < segments.length; i++) {
        if (segments[i] == 'invoice' && i + 1 < segments.length) {
          final invoiceId = int.tryParse(segments[i + 1]);
          if (invoiceId != null && invoiceId > 0) {
            return invoiceId;
          }
        }
      }

      // If 'p' or 'invoice' not found, try to parse last segment as invoice ID
      if (segments.isNotEmpty) {
        final invoiceId = int.tryParse(segments.last);
        if (invoiceId != null && invoiceId > 0) {
          return invoiceId;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  void _handleBarcode(BarcodeCapture barcodeCapture) {
    final barcodes = barcodeCapture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null) return;

    final qrCode = barcode.rawValue!;
    final invoiceId = _extractInvoiceId(qrCode);

    if (invoiceId == null) {
      widget.onScanError('Invalid QR code format');
      return;
    }

    // Stop scanning
    _controller.stop();

    // Call success callback
    widget.onScanSuccess(invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const BackButtonWidget(iconColor: Colors.white),
        title: Text(
          S.of(context).scanQrCode,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
          ),

          // Overlay with scanning area
          Center(
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 3.w,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 100.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  S.of(context).scanQrCodeInstructions,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

