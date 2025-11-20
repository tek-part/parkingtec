import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';

/// Ticket Image Builder Widget
/// Builds ticket layout matching the reference design
/// Used for image-based printing
class TicketImageBuilder extends StatelessWidget {
  final Invoice invoice;
  final AppConfig appConfig;
  final bool isExitReceipt;

  const TicketImageBuilder({
    super.key,
    required this.invoice,
    required this.appConfig,
    this.isExitReceipt = false,
  });

  @override
  Widget build(BuildContext context) {
    final systemName = appConfig.systemName ?? 'Express Parking';
    final currency = appConfig.currencySymbol ?? 'Rs';
    final date = _formatDate(invoice.startTime);
    final entryTime = _formatTime(invoice.startTime);
    final exitTime = invoice.endTime != null ? _formatTime(invoice.endTime!) : '';
    final duration = invoice.durationHours > 0
        ? (invoice.durationHours * 60).toInt()
        : 0;
    final amount = invoice.finalAmount ?? invoice.amount ?? 0.0;
    final supervisor = invoice.wardenName ?? 'Parking Supervisor';
    final ticketNo = invoice.invoiceId.toString();

    // Paper width: 80mm = ~300px at 96 DPI, 58mm = ~220px
    // Use fixed width for consistent printing
    const double paperWidth = 300.0;
    const double padding = 16.0;

    return Container(
      width: paperWidth,
      color: Colors.white,
      padding: const EdgeInsets.all(padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - System Name (bold, centered)
          Center(
            child: Text(
              systemName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Date
          Text(
            'Date $date',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // In/Out times
          if (isExitReceipt)
            Text(
              'In  $entryTime    Out $exitTime',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            )
          else
            Text(
              'In  $entryTime',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          const SizedBox(height: 16),

          // Dashed line separator
          CustomPaint(
            painter: DashedLinePainter(),
            size: const Size(double.infinity, 1),
          ),
          const SizedBox(height: 16),

          // Duration and Amount (side by side for exit receipt)
          if (isExitReceipt) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration  Min $duration',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Amount  $currency $amount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ] else if (appConfig.showPrices) ...[
            // For entry ticket, show amount if available
            if (invoice.isHourlyPricing && invoice.hourlyRate != null)
              Text(
                'Rate  $currency${invoice.hourlyRate}/hour',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              )
            else if (invoice.amount != null)
              Text(
                'Amount  $currency${invoice.amount}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
          ],
          const SizedBox(height: 16),

          // Dashed line separator
          CustomPaint(
            painter: DashedLinePainter(),
            size: const Size(double.infinity, 1),
          ),
          const SizedBox(height: 16),

          // Parking Supervisor
          Text(
            'Parking Supervisor - $supervisor',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // Ticket No and QR Code (side by side)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ticket No $ticketNo',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              // QR Code
              if (invoice.hasQrCode && invoice.qrCode != null)
                _buildQrCodeWidget(invoice.qrCode!),
            ],
          ),
          const SizedBox(height: 16),

          // Thank You
          const Center(
            child: Text(
              'Thank You',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQrCodeWidget(String qrCodeData) {
    // Check if the data is SVG format
    if (qrCodeData.trim().startsWith('<?xml') ||
        qrCodeData.trim().startsWith('<svg')) {
      // It's SVG, render it
      return SizedBox(
        width: 80,
        height: 80,
        child: SvgPicture.string(
          qrCodeData,
          fit: BoxFit.contain,
        ),
      );
    } else {
      // It's plain text or URL - generate QR code using qr_flutter
      // Extract invoice ID from URL if it's a URL
      String qrData = qrCodeData;
      final uri = Uri.tryParse(qrCodeData);
      if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
        // It's a URL, use it as-is
        qrData = qrCodeData;
      } else {
        // It's plain text, use invoice ID
        qrData = invoice.invoiceId.toString();
      }

      return SizedBox(
        width: 80,
        height: 80,
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 80,
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}

/// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

