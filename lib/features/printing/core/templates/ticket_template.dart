import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';
import 'package:parkingtec/core/constants/api_endpoints.dart';
import 'package:parkingtec/core/utils/app_images.dart';
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
    int maxSliceHeightPx = 200,
    String fontFamily = 'Cairo',
    Function(double progress)? onProgress,
  }) async {
    return _renderTicket(
      paperWidthPx: paperWidthPx,
      invoice: invoice,
      appConfig: appConfig,
      isExitReceipt: false,
      maxSliceHeightPx: maxSliceHeightPx,
      fontFamily: fontFamily,
      onProgress: onProgress,
    );
  }

  /// Render exit receipt to image bytes
  static Future<List<Uint8List>> renderExitReceipt({
    required int paperWidthPx,
    required Invoice invoice,
    required AppConfig appConfig,
    int maxSliceHeightPx = 200,
    String fontFamily = 'Cairo',
    Function(double progress)? onProgress,
  }) async {
    return _renderTicket(
      paperWidthPx: paperWidthPx,
      invoice: invoice,
      appConfig: appConfig,
      isExitReceipt: true,
      maxSliceHeightPx: maxSliceHeightPx,
      fontFamily: fontFamily,
      onProgress: onProgress,
    );
  }

  /// Main render method
  static Future<List<Uint8List>> _renderTicket({
    required int paperWidthPx,
    required Invoice invoice,
    required AppConfig appConfig,
    required bool isExitReceipt,
    int maxSliceHeightPx = 200,
    String fontFamily = 'Cairo',
    Function(double progress)? onProgress,
  }) async {
    // Adaptive margin: 2% of paper width, min 8.0, max 15.0
    final margin = math.max(8.0, math.min(15.0, paperWidthPx * 0.02));
    final contentWidth = paperWidthPx.toDouble() - margin * 2;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    double y = margin;

    // White background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, paperWidthPx.toDouble(), 30000),
      Paint()..color = Colors.white,
    );

    // Calculate font size based on paper width
    // 58mm (256px) -> base size 20, 80mm (384px) -> base size 28, 110mm (528px) -> base size 36
    final baseFontSize = paperWidthPx <= 256
        ? 20.0
        : paperWidthPx <= 384
        ? 20.0 +
              ((paperWidthPx - 256) / 128 * 8) // 58mm to 80mm
        : 28.0 + ((paperWidthPx - 384) / 144 * 8); // 80mm to 110mm and beyond

    final headerFontSize = baseFontSize * 1.2;
    final titleFontSize = baseFontSize * 1.1;
    final totalFontSize = baseFontSize * 1.15;

    // Base text style with font family for Arabic support
    // Use google_fonts if available, otherwise use system font
    // For printing, we need a font that supports Arabic characters
    final baseStyle = TextStyle(
      fontSize: baseFontSize,
      color: Colors.black,
      height: 1.2,
      fontFamily: fontFamily.isNotEmpty
          ? fontFamily
          : null, // Use fontFamily if provided
      // Ensure proper text rendering for Arabic
      locale: const Locale('ar', 'SA'),
      // Fallback to system font if fontFamily is not available
      // Flutter will automatically use a font that supports Arabic
    );

    final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);

    // ---- 1. APP LOGO ----
    final logoSize = paperWidthPx * 0.60; // 70% of paper width (larger)
    y = await _drawImageWithColorFilter(
      canvas,
      AppImages.wafyParking,
      (paperWidthPx - logoSize) / 2, // Center horizontally
      y,
      logoSize,
      logoSize,
      Colors.black, // Convert to black color
    );
    y += 5; // Reduced spacing

    // ---- 2. TICKET TYPE ----
    y = _drawText(
      canvas,
      isExitReceipt ? 'EXIT RECEIPT' : 'ENTRY TICKET',
      margin,
      y,
      contentWidth,
      boldStyle.copyWith(fontSize: titleFontSize),
      TextAlign.center,
      ui.TextDirection.ltr,
    );
    y += 5;

    // Draw line
    canvas.drawLine(
      Offset(0, y),
      Offset(paperWidthPx - 0, y),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 3.0,
    );
    y += 5;

    // ---- 3. TIME/DATE/HOURS ----
    y = _drawText(
      canvas,
      'In: ${_formatDate(invoice.startTime)}   time: ${_formatTime(invoice.startTime)}',
      margin,
      y,
      contentWidth,
      baseStyle,
      TextAlign.center,
      ui.TextDirection.ltr,
    );
    y += 8;

    if (isExitReceipt && invoice.endTime != null) {
      y = _drawText(
        canvas,
        'Out: ${_formatDate(invoice.endTime!)}   time: ${_formatTime(invoice.endTime!)}',
        margin,
        y,
        contentWidth,
        baseStyle,
        TextAlign.center,
        ui.TextDirection.ltr,
      );
      y += 8;
    }

    if (isExitReceipt && invoice.durationHours > 0) {
      y = _drawText(
        canvas,
        'Duration: ${invoice.durationHours.toStringAsFixed(1)} h',
        margin,
        y,
        contentWidth,
        baseStyle,
        TextAlign.center,
        ui.TextDirection.ltr,
      );
      y += 8;
    }

    y += 5;

    // Draw line
    canvas.drawLine(
      Offset(0, y),
      Offset(paperWidthPx - 0, y),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 1.0,
    );
    y += 5;

    // ---- 4. INVOICE NUMBER (LARGE, CENTERED) ----
    y = _drawText(
      canvas,
      '${invoice.invoiceId}',
      margin,
      y,
      contentWidth,
      boldStyle.copyWith(
        fontSize: headerFontSize * 1.6,
      ), // Larger than other text
      TextAlign.center,
      ui.TextDirection.ltr,
    );
    y += 5;

    // Draw line
    canvas.drawLine(
      Offset(0, y),
      Offset(paperWidthPx - 0, y),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 1.0,
    );
    y += 5;

    // ---- 5. CAR NUMBER (Label at start, value at end) ----
    y = _drawTextWithLabel(
      canvas,
      'Car Number:',
      invoice.carNum,
      margin,
      y,
      contentWidth,
      baseStyle,
    );
    y += 8;

    // ---- 6. CAR MODEL (Label at start, value at end) ----
    if ((invoice.carModel ?? '').isNotEmpty) {
      y = _drawTextWithLabel(
        canvas,
        'Car Model:',
        invoice.carModel!,
        margin,
        y,
        contentWidth,
        baseStyle,
      );
      y += 8;
    }

    // ---- 7. CUSTOMER NAME (Label at start, value at end) ----
    if ((invoice.customerName ?? '').isNotEmpty) {
      y = _drawTextWithLabel(
        canvas,
        'Customer:',
        invoice.customerName!,
        margin,
        y,
        contentWidth,
        baseStyle,
      );
      y += 8;
    }

    y += 8;

    // Draw line
    canvas.drawLine(
      Offset(0, y),
      Offset(paperWidthPx - 0, y),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 1.0,
    );
    y += 5;

    // ---- 8. TOTAL PAID (Only for exit receipt) ----
    if (isExitReceipt && invoice.finalAmount != null) {
      y = _drawText(
        canvas,
        'TOTAL: ${invoice.finalAmount?.round() ?? 0} ${appConfig.currencySymbol ?? "DM"}',
        margin,
        y,
        contentWidth,
        boldStyle.copyWith(fontSize: totalFontSize),
        TextAlign.center,

        ((appConfig.currencySymbol ?? "DM") == "د.ع" ||
                (appConfig.currencySymbol ?? "DM") == "د.م" ||
                (appConfig.currencySymbol ?? "DM").contains('د'))
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
      );
      y += 5;

      // Draw line
      canvas.drawLine(
        Offset(0, y),
        Offset(paperWidthPx - 0, y),
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1.0,
      );
      y += 5;
    }

    // ---- QR CODE ----
    if (invoice.hasQrCode) {
      final qrSize = 250.0;
      final qrX = (paperWidthPx - qrSize) / 2;
      await _drawQrCode(
        canvas,
        invoice.qrCode ?? '',
        qrX,
        y,
        qrSize,
        invoiceId: invoice.invoiceId,
      );
      y += qrSize + 16;
    }

    // ---- 10. THANK YOU MESSAGE ----
    y = _drawText(
      canvas,
      'Thank You!',
      margin,
      y,
      contentWidth,
      boldStyle,
      TextAlign.center,
      ui.TextDirection.ltr,
    );
    y += 5;

    // Convert to image
    final image = await recorder.endRecording().toImage(
      paperWidthPx,
      y.ceil() + 2,
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
    // Detect if text contains Arabic characters
    final hasArabic = _containsArabic(text);
    final effectiveDirection = hasArabic ? ui.TextDirection.rtl : direction;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: align,
      textDirection: effectiveDirection,
      maxLines: null,
      locale: const Locale('ar', 'SA'), // Support Arabic locale
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

  /// Draw text with label at start and value at end
  static double _drawTextWithLabel(
    Canvas canvas,
    String label,
    String value,
    double x,
    double y,
    double width,
    TextStyle style,
  ) {
    // Detect if text contains Arabic characters
    final hasArabic = _containsArabic(label) || _containsArabic(value);
    final effectiveDirection = hasArabic
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;

    // Draw label
    final labelPainter = TextPainter(
      text: TextSpan(text: label, style: style),
      textAlign: TextAlign.left,
      textDirection: effectiveDirection,
      maxLines: null,
      locale: const Locale('ar', 'SA'),
    )..layout(maxWidth: width > 0 ? width : double.infinity);

    labelPainter.paint(canvas, Offset(x, y));

    // Draw value at end
    final valuePainter = TextPainter(
      text: TextSpan(text: value, style: style),
      textAlign: TextAlign.right,
      textDirection: effectiveDirection,
      maxLines: null,
      locale: const Locale('ar', 'SA'),
    )..layout(maxWidth: width > 0 ? width : double.infinity);

    final valueX = x + width - valuePainter.width;
    valuePainter.paint(canvas, Offset(valueX, y));

    // Return the maximum height
    return y + math.max(labelPainter.height, valuePainter.height);
  }

  /// Draw image from asset
  static Future<double> _drawImage(
    Canvas canvas,
    String assetPath,
    double x,
    double y,
    double width,
    double height,
  ) async {
    try {
      // Load asset
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Decode image
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // Draw image
      final srcRect = Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final dstRect = Rect.fromLTWH(x, y, width, height);
      canvas.drawImageRect(image, srcRect, dstRect, Paint());

      return y + height;
    } catch (e) {
      debugPrint('Error loading image from asset: $e');
      // Return original y if image fails to load
      return y;
    }
  }

  /// Draw image from asset with color filter (e.g., convert to black)
  static Future<double> _drawImageWithColorFilter(
    Canvas canvas,
    String assetPath,
    double x,
    double y,
    double width,
    double height,
    Color targetColor,
  ) async {
    try {
      // Load asset
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Decode image
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // Create color filter to convert image to target color (black)
      // Convert to grayscale first, then apply target color
      final r = targetColor.red / 255.0;
      final g = targetColor.green / 255.0;
      final b = targetColor.blue / 255.0;

      // Matrix: Convert to grayscale (luminance), then multiply by target color
      final matrix = ColorFilter.matrix([
        r * 0.2126, r * 0.7152, r * 0.0722, 0, 0, // Red channel
        g * 0.2126, g * 0.7152, g * 0.0722, 0, 0, // Green channel
        b * 0.2126, b * 0.7152, b * 0.0722, 0, 0, // Blue channel
        0, 0, 0, 1, 0, // Alpha channel (preserve)
      ]);

      // Draw image with color filter
      final srcRect = Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final dstRect = Rect.fromLTWH(x, y, width, height);
      canvas.drawImageRect(
        image,
        srcRect,
        dstRect,
        Paint()..colorFilter = matrix,
      );

      return y + height;
    } catch (e) {
      debugPrint('Error loading image from asset with color filter: $e');
      // Return original y if image fails to load
      return y;
    }
  }

  /// Check if text contains Arabic characters
  static bool _containsArabic(String text) {
    for (int i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      // Arabic Unicode range: U+0600 to U+06FF
      if (codeUnit >= 0x0600 && codeUnit <= 0x06FF) {
        return true;
      }
    }
    return false;
  }

  /// Construct invoice QR code URL from invoice ID
  /// Uses pattern: {baseUrl}/p/{invoice_id}
  /// Extracts base URL from ApiEndpoints.baseUrl and removes /api suffix for public URLs
  static String? _constructInvoiceQrUrl(int invoiceId) {
    if (invoiceId <= 0) return null;

    try {
      // Extract base URL from ApiEndpoints.baseUrl
      // baseUrl format: "https://parking.alwafierp.com/api" (with extra quotes)
      // For public invoice: https://parking.alwafierp.com/p/{id}
      String baseUrl = ApiEndpoints.baseUrl;

      // Remove quotes if present
      baseUrl = baseUrl.replaceAll('"', '').trim();

      // Remove /api suffix if present (for public URLs, we don't need /api)
      if (baseUrl.endsWith('/api')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 4);
      }

      // Construct URL using /p/{id} pattern (matching ApiEndpoints.publicInvoice)
      return '$baseUrl/p/$invoiceId';
    } catch (e) {
      debugPrint('Error constructing QR URL: $e');
      return null;
    }
  }

  /// Draw QR Code on canvas with SVG support
  static Future<void> _drawQrCode(
    Canvas canvas,
    String qrCodeData,
    double x,
    double y,
    double size, {
    int? invoiceId,
  }) async {
    try {
      String? finalQrData;

      // Step 1: Try rendering the SVG directly first
      if (qrCodeData.trim().startsWith('<?xml') ||
          qrCodeData.trim().startsWith('<svg')) {
        final svgImage = await _renderSvgToImage(qrCodeData, size);
        if (svgImage != null) {
          canvas.save();
          canvas.translate(x, y);
          canvas.drawImage(svgImage, Offset.zero, Paint());
          canvas.restore();
          return; // Successfully rendered SVG
        }

        // Step 2: If SVG rendering fails, construct URL from invoice ID
        if (invoiceId != null && invoiceId > 0) {
          finalQrData = _constructInvoiceQrUrl(invoiceId);
        }

        // Step 3: If construction fails, use invoice ID as QR data
        if (finalQrData == null || finalQrData.isEmpty) {
          if (invoiceId != null) {
            finalQrData = invoiceId.toString();
          } else {
            return; // No valid data
          }
        }
      } else {
        // Not SVG format - check if it's already a URL
        final uri = Uri.tryParse(qrCodeData);
        if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
          finalQrData = qrCodeData; // Use URL as-is
        } else {
          // Not a URL - validate and use as-is or construct from invoice ID
          if (qrCodeData.isNotEmpty && _isValidQrCode(qrCodeData)) {
            finalQrData = qrCodeData;
          } else if (invoiceId != null && invoiceId > 0) {
            // Try to construct URL from invoice ID
            finalQrData =
                _constructInvoiceQrUrl(invoiceId) ?? invoiceId.toString();
          } else {
            finalQrData = qrCodeData.isNotEmpty ? qrCodeData : null;
          }
        }
      }

      if (finalQrData == null || finalQrData.isEmpty) {
        return;
      }

      // Create QR Painter with the final data
      final qrPainter = QrPainter(
        data: finalQrData,
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
    } catch (e) {
      // If QR rendering fails, just skip it (ticket number will still show)
      debugPrint('QR Code rendering error: $e');
    }
  }

  /// Render SVG string to ui.Image
  /// Note: SVG rendering in canvas context is complex, so we fallback to invoice ID
  static Future<ui.Image?> _renderSvgToImage(
    String svgString,
    double size,
  ) async {
    // For now, skip SVG rendering in canvas context
    // SVG rendering requires widget tree which is not available in canvas
    // Fallback to invoice ID will be used instead
    return null;
  }

  /// Validate QR code format
  static bool _isValidQrCode(String qrCodeData) {
    if (qrCodeData.isEmpty) return false;

    // Check if it's valid SVG
    if (qrCodeData.trim().startsWith('<?xml') ||
        qrCodeData.trim().startsWith('<svg')) {
      return qrCodeData.contains('<svg') && qrCodeData.contains('</svg>');
    }

    // Check if it's valid URL
    final uri = Uri.tryParse(qrCodeData);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return true;
    }

    // Check if it's valid text (not too long for QR)
    return qrCodeData.length <= 2000; // Reasonable limit for QR codes
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
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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
      // Draw only the image slice without extra white background
      // This prevents extra spacing between chunks when printing
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
