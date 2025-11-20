import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Ticket Template Renderer
/// Renders parking ticket/receipt using Canvas directly (like tax_invoice_template.dart)
/// Returns Uint8List image bytes ready for printing
class TicketTemplateRenderer {
  /// Render entry ticket to image bytes
  static Future<List<Uint8List>> renderEntryTicket({
    required int paperWidthPx,
    required Invoice invoice,
    required AppConfig appConfig,
    int maxSliceHeightPx = 900,
    Function(double progress)? onProgress,
  }) async {
    return _renderTicket(
      paperWidthPx: paperWidthPx,
      invoice: invoice,
      appConfig: appConfig,
      isExitReceipt: false,
      maxSliceHeightPx: maxSliceHeightPx,
      onProgress: onProgress,
    );
  }

  /// Render exit receipt to image bytes
  static Future<List<Uint8List>> renderExitReceipt({
    required int paperWidthPx,
    required Invoice invoice,
    required AppConfig appConfig,
    int maxSliceHeightPx = 900,
    Function(double progress)? onProgress,
  }) async {
    return _renderTicket(
      paperWidthPx: paperWidthPx,
      invoice: invoice,
      appConfig: appConfig,
      isExitReceipt: true,
      maxSliceHeightPx: maxSliceHeightPx,
      onProgress: onProgress,
    );
  }

  /// Main render method
  static Future<List<Uint8List>> _renderTicket({
    required int paperWidthPx,
    required Invoice invoice,
    required AppConfig appConfig,
    required bool isExitReceipt,
    int maxSliceHeightPx = 900,
    Function(double progress)? onProgress,
  }) async {
    final margin = 12.0;
    final contentWidth = paperWidthPx.toDouble() - margin * 2;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    double y = margin;

    // White background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, paperWidthPx.toDouble(), 30000),
      Paint()..color = Colors.white,
    );

    // Base text style
    final baseStyle = TextStyle(
      fontSize: 20,
      color: Colors.black,
      height: 1.2,
    );

    final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);

    // System Name (centered, bold)
    final systemName = appConfig.systemName ?? 'Express Parking';
    y = _drawText(
      canvas,
      systemName,
      margin,
      y,
      contentWidth,
      boldStyle.copyWith(fontSize: 24),
      TextAlign.center,
      ui.TextDirection.ltr,
    );
    y += 8;

    // Ticket Type (centered)
    final ticketType = isExitReceipt ? 'EXIT RECEIPT' : 'ENTRY TICKET';
    y = _drawText(
      canvas,
      ticketType,
      margin,
      y,
      contentWidth,
      boldStyle.copyWith(fontSize: 22),
      TextAlign.center,
      ui.TextDirection.ltr,
    );
    y += 12;

    // Dashed line
    _drawDashedLine(canvas, margin, y, margin + contentWidth, y);
    y += 12;

    // Date
    final date = _formatDate(invoice.startTime);
    y = _drawText(
      canvas,
      'Date $date',
      margin,
      y,
      contentWidth,
      baseStyle,
      TextAlign.left,
      ui.TextDirection.ltr,
    );
    y += 8;

    // In/Out times
    final entryTime = _formatTime(invoice.startTime);
    if (isExitReceipt) {
      final exitTime = invoice.endTime != null ? _formatTime(invoice.endTime!) : '-';
      y = _drawText(
        canvas,
        'In  $entryTime    Out $exitTime',
        margin,
        y,
        contentWidth,
        baseStyle,
        TextAlign.left,
        ui.TextDirection.ltr,
      );
    } else {
      y = _drawText(
        canvas,
        'In  $entryTime',
        margin,
        y,
        contentWidth,
        baseStyle,
        TextAlign.left,
        ui.TextDirection.ltr,
      );
    }
    y += 12;

    // Dashed line
    _drawDashedLine(canvas, margin, y, margin + contentWidth, y);
    y += 12;

    // Duration and Amount (for exit receipt)
    if (isExitReceipt) {
      final duration = invoice.durationHours > 0
          ? (invoice.durationHours * 60).toInt()
          : 0;
      final currency = appConfig.currencySymbol ?? 'Rs';
      final amount = invoice.finalAmount ?? invoice.amount ?? 0.0;

      // Duration and Amount side by side
      final durationText = 'Duration  Min $duration';
      final amountText = 'Amount  $currency $amount';

      // Draw duration on left
      _drawText(
        canvas,
        durationText,
        margin,
        y,
        contentWidth * 0.5,
        boldStyle.copyWith(fontSize: 22),
        TextAlign.left,
        ui.TextDirection.ltr,
      );

      // Draw amount on right (green color)
      _drawText(
        canvas,
        amountText,
        margin + contentWidth * 0.5,
        y,
        contentWidth * 0.5,
        boldStyle.copyWith(fontSize: 22, color: Colors.green),
        TextAlign.right,
        ui.TextDirection.ltr,
      );

      y += 28;
    } else if (appConfig.showPrices) {
      // For entry ticket, show rate or amount
      final currency = appConfig.currencySymbol ?? 'Rs';
      if (invoice.isHourlyPricing && invoice.hourlyRate != null) {
        y = _drawText(
          canvas,
          'Rate  $currency${invoice.hourlyRate}/hour',
          margin,
          y,
          contentWidth,
          baseStyle,
          TextAlign.left,
          ui.TextDirection.ltr,
        );
        y += 8;
      } else if (invoice.amount != null) {
        y = _drawText(
          canvas,
          'Amount  $currency${invoice.amount}',
          margin,
          y,
          contentWidth,
          baseStyle,
          TextAlign.left,
          ui.TextDirection.ltr,
        );
        y += 8;
      }
    }

    // Dashed line
    _drawDashedLine(canvas, margin, y, margin + contentWidth, y);
    y += 12;

    // Parking Supervisor
    final supervisor = invoice.wardenName ?? 'Parking Supervisor';
    y = _drawText(
      canvas,
      'Parking Supervisor - $supervisor',
      margin,
      y,
      contentWidth,
      baseStyle,
      TextAlign.left,
      ui.TextDirection.ltr,
    );
    y += 8;

    // Ticket No and QR Code (side by side)
    final ticketNo = invoice.invoiceId.toString();
    final ticketNoText = 'Ticket No $ticketNo';

    if (invoice.hasQrCode && invoice.qrCode != null) {
      // Draw ticket number on left
      _drawText(
        canvas,
        ticketNoText,
        margin,
        y,
        contentWidth * 0.5,
        baseStyle,
        TextAlign.left,
        ui.TextDirection.ltr,
      );

      // Draw QR Code on right
      final qrSize = 80.0;
      final qrX = margin + contentWidth - qrSize;
      final qrY = y - 10; // Adjust position slightly

      await _drawQrCode(
        canvas,
        invoice.qrCode!,
        qrX,
        qrY,
        qrSize,
      );

      y += qrSize + 8;
    } else {
      y = _drawText(
        canvas,
        ticketNoText,
        margin,
        y,
        contentWidth,
        baseStyle,
        TextAlign.left,
        ui.TextDirection.ltr,
      );
      y += 8;
    }

    y += 12;

    // Thank You (centered, bold)
    y = _drawText(
      canvas,
      'Thank You',
      margin,
      y,
      contentWidth,
      boldStyle.copyWith(fontSize: 22),
      TextAlign.center,
      ui.TextDirection.ltr,
    );
    y += 16;

    // Convert to image
    final image = await recorder.endRecording().toImage(
      paperWidthPx,
      y.ceil() + 4,
    );

    // Slice to chunks if needed
    return _sliceToChunksWithProgress(
      image,
      paperWidthPx,
      maxSliceHeightPx,
      onProgress,
    );
  }

  /// Draw text on canvas
  static double _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double width,
    TextStyle style,
    TextAlign align,
    ui.TextDirection direction,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: align,
      textDirection: direction,
      maxLines: null,
    )..layout(maxWidth: width > 0 ? width : double.infinity);

    double dx = x;
    if (align == TextAlign.center) {
      dx = x + (width - textPainter.width) / 2;
    } else if (align == TextAlign.right) {
      dx = x + width - textPainter.width;
    }

    textPainter.paint(canvas, Offset(dx, y));
    return y + textPainter.height;
  }

  /// Draw dashed line
  static void _drawDashedLine(
    Canvas canvas,
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = x1;

    while (startX < x2) {
      final endX = math.min(startX + dashWidth, x2);
      canvas.drawLine(
        Offset(startX, y1),
        Offset(endX, y1),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  /// Draw QR Code on canvas
  static Future<void> _drawQrCode(
    Canvas canvas,
    String qrCodeData,
    double x,
    double y,
    double size,
  ) async {
    // Check if SVG format
    if (qrCodeData.trim().startsWith('<?xml') ||
        qrCodeData.trim().startsWith('<svg')) {
      // For SVG, we need to render it to image first
      // For now, skip SVG and use text-based QR
      return;
    }

    // Extract QR data
    String qrData = qrCodeData;
    final uri = Uri.tryParse(qrCodeData);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      qrData = qrCodeData;
    } else {
      // If it's not a URL, try to extract invoice ID from it
      // For now, use as-is
      qrData = qrCodeData;
    }

      // Create QR Painter
      final qrPainter = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: true,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
        errorCorrectionLevel: QrErrorCorrectLevel.H,
      );

    // Save canvas state
    canvas.save();

    // Translate to QR position
    canvas.translate(x, y);

    // Paint QR code
    qrPainter.paint(canvas, Size(size, size));

    // Restore canvas state
    canvas.restore();
  }

  /// Format date from ISO string
  static String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  /// Format time from ISO string
  static String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }

  /// Slice image to chunks for long receipts
  static Future<List<Uint8List>> _sliceToChunksWithProgress(
    ui.Image img,
    int width,
    int maxH,
    Function(double progress)? onProgress,
  ) async {
    final list = <Uint8List>[];
    int y = 0;
    final totalHeight = img.height;

    while (y < totalHeight) {
      // Yield before heavy operations
      await Future.microtask(() {});
      await SchedulerBinding.instance.endOfFrame;

      final h = (y + maxH <= totalHeight) ? maxH : (totalHeight - y);
      final rec = ui.PictureRecorder();
      final c = Canvas(rec);
      final dst = Rect.fromLTWH(0, 0, width.toDouble(), h.toDouble());
      final src = Rect.fromLTWH(
        0,
        y.toDouble(),
        width.toDouble(),
        h.toDouble(),
      );
      c.drawRect(dst, Paint()..color = Colors.white);
      c.drawImageRect(img, src, dst, Paint());

      // Yield before toImage
      await Future.microtask(() {});
      await SchedulerBinding.instance.endOfFrame;

      final part = await rec.endRecording().toImage(width, h);

      // Yield before toByteData
      await Future.microtask(() {});
      await SchedulerBinding.instance.endOfFrame;

      final png = await part.toByteData(format: ui.ImageByteFormat.png);
      list.add(png!.buffer.asUint8List());

      y += h;

      // Update progress
      onProgress?.call(y / totalHeight);

      // Yield after each slice
      await Future.microtask(() {});
    }

    return list;
  }
}

