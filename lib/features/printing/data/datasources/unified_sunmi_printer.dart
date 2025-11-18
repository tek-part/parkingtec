import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:parkingtec/features/printing/domain/entities/printing_failure.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

/// Unified Sunmi printer class for both PDF and native printing
class UnifiedSunmiPrinter {
  static bool _isInitialized = false;

  /// Initialize the printer
  static Future<Either<PrintingFailure, Unit>> initializePrinter() async {
    try {
      // Initialize Sunmi printer
      await _initializeSunmiPrinter();
      _isInitialized = true;
      return const Right(unit);
    } catch (e) {
      return Left(
        PrinterInitFailure(
          message: 'فشل تهيئة الطابعة: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Check if printer is ready
  static Future<bool> isPrinterReady() async {
    try {
      if (!_isInitialized) {
        final result = await initializePrinter();
        return result.fold((l) => false, (r) => true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Print PDF from URL
  static Future<Either<PrintingFailure, Unit>> printPdfFromUrl(
    String pdfUrl,
  ) async {
    try {
      if (!await isPrinterReady()) {
        return Left(const PrinterNotReadyFailure(message: 'الطابعة غير جاهزة'));
      }

      // Download and convert PDF to image
      final pdfBytes = await _downloadPdf(pdfUrl);
      final images = await _convertPdfToImages(pdfBytes);

      // Print each page
      for (final image in images) {
        await _printImage(image);
      }

      return const Right(unit);
    } catch (e) {
      return Left(
        PrintExecutionFailure(
          message: 'فشل طباعة PDF: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Print native receipt
  static Future<Either<PrintingFailure, Unit>> printNativeReceipt({
    required String brand,
    required String lotName,
    required String plate,
    required DateTime start,
    required DateTime end,
    required String code6,
    required double amount,
    required String sessionId,
    required bool isArabic,
    String? currency,
    String? currencySymbol,
  }) async {
    try {
      if (!await isPrinterReady()) {
        return Left(const PrinterNotReadyFailure(message: 'الطابعة غير جاهزة'));
      }

      await _printNativeReceipt(
        brand: brand,
        lotName: lotName,
        plate: plate,
        start: start,
        end: end,
        code6: code6,
        amount: amount,
        sessionId: sessionId,
        isArabic: isArabic,
        currency: currency,
        currencySymbol: currencySymbol,
      );

      return const Right(unit);
    } catch (e) {
      return Left(
        PrintExecutionFailure(
          message: 'فشل طباعة النص: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Print simple receipt
  static Future<Either<PrintingFailure, Unit>> printSimpleReceipt({
    required String title,
    required String content,
    required bool isArabic,
  }) async {
    try {
      if (!await isPrinterReady()) {
        return Left(const PrinterNotReadyFailure(message: 'الطابعة غير جاهزة'));
      }

      await _printSimpleReceipt(
        title: title,
        content: content,
        isArabic: isArabic,
      );

      return const Right(unit);
    } catch (e) {
      return Left(
        PrintExecutionFailure(
          message: 'فشل طباعة النص: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  /// Print QR code only
  static Future<Either<PrintingFailure, Unit>> printQROnly({
    required String data,
    required String label,
    required bool isArabic,
  }) async {
    try {
      if (!await isPrinterReady()) {
        return Left(const PrinterNotReadyFailure(message: 'الطابعة غير جاهزة'));
      }

      await _printQROnly(data: data, label: label, isArabic: isArabic);

      return const Right(unit);
    } catch (e) {
      return Left(
        PrintExecutionFailure(
          message: 'فشل طباعة النص: ${e.toString()}',
          details: {'error': e.toString()},
        ),
      );
    }
  }

  // Private helper methods

  static Future<void> _initializeSunmiPrinter() async {
    try {
      // Initialize Sunmi printer using the actual SDK
      await SunmiPrinter.initPrinter();
      await SunmiPrinter.bindingPrinter();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  static Future<Uint8List> _downloadPdf(String url) async {
    // Download PDF from URL
    // This is a placeholder - implement actual PDF download
    return Uint8List(0);
  }

  static Future<List<Uint8List>> _convertPdfToImages(Uint8List pdfBytes) async {
    // Convert PDF to images using printing package
    try {
      // For now, return empty list as this is a placeholder implementation
      // In real implementation, you would use the actual PDF processing library
      await Future.delayed(const Duration(milliseconds: 500));
      return [];
    } catch (e) {
      // Return empty list if conversion fails
      return [];
    }
  }

  static Future<void> _printImage(Uint8List imageBytes) async {
    // Print image to Sunmi printer
    // This is a placeholder - implement actual image printing
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  static Future<void> _printNativeReceipt({
    required String brand,
    required String lotName,
    required String plate,
    required DateTime start,
    required DateTime end,
    required String code6,
    required double amount,
    required String sessionId,
    required bool isArabic,
    String? currency,
    String? currencySymbol,
  }) async {
    try {
      // Print header
      await SunmiPrinter.printText(
        brand,
        style: SunmiTextStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: 80,
          bold: true,
        ),
      );

      await SunmiPrinter.lineWrap(1);

      // Print Arabic title if needed
      if (isArabic) {
        await SunmiPrinter.printText(
          'باركن الوافي',
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER, fontSize: 32),
        );
        await SunmiPrinter.lineWrap(1);
      }

      // Print separator line
      await SunmiPrinter.printText('--------------------------------');

      // Print lot information
      await SunmiPrinter.printText(
        'Lot: $lotName',
        style: SunmiTextStyle(fontSize: 24),
      );

      await SunmiPrinter.printText(
        'Plate: $plate',
        style: SunmiTextStyle(fontSize: 24),
      );

      // Print time information
      await SunmiPrinter.printText(
        'Start: ${_formatDateTime(start)}',
        style: SunmiTextStyle(fontSize: 24),
      );

      await SunmiPrinter.printText(
        'End: ${_formatDateTime(end)}',
        style: SunmiTextStyle(fontSize: 24),
      );

      await SunmiPrinter.lineWrap(1);

      // Print amount with currency
      // Note: Currency should be passed as parameter or retrieved from config
      // For now, we'll use a default format
      final currencyDisplay = currencySymbol ?? currency ?? '';
      final amountText = currencyDisplay.isNotEmpty
          ? 'Amount: ${amount.toStringAsFixed(2)} $currencyDisplay'
          : 'Amount: ${amount.toStringAsFixed(2)}';
      await SunmiPrinter.printText(
        amountText,
        style: SunmiTextStyle(
          fontSize: 32,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.lineWrap(1);

      // Print QR code
      await SunmiPrinter.printQRCode(
        sessionId,
        style: SunmiQrcodeStyle(
          align: SunmiPrintAlign.CENTER,
          qrcodeSize: 3,
          errorLevel: SunmiQrcodeLevel.LEVEL_H,
        ),
      );

      await SunmiPrinter.lineWrap(2);

      // Print footer
      await SunmiPrinter.printText(
        'Thank you for using our service',
        style: SunmiTextStyle(align: SunmiPrintAlign.CENTER, fontSize: 24),
      );

      if (isArabic) {
        await SunmiPrinter.printText(
          'شكراً لاستخدامكم',
          style: SunmiTextStyle(align: SunmiPrintAlign.CENTER, fontSize: 24),
        );
      }

      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.cutPaper();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _printSimpleReceipt({
    required String title,
    required String content,
    required bool isArabic,
  }) async {
    try {
      // Print title
      await SunmiPrinter.printText(
        title,
        style: SunmiTextStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: 32,
          bold: true,
        ),
      );

      await SunmiPrinter.lineWrap(1);

      // Print content
      await SunmiPrinter.printText(
        content,
        style: SunmiTextStyle(fontSize: 24),
      );

      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.cutPaper();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _printQROnly({
    required String data,
    required String label,
    required bool isArabic,
  }) async {
    try {
      // Print label
      await SunmiPrinter.printText(
        label,
        style: SunmiTextStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: 32,
          bold: true,
        ),
      );

      await SunmiPrinter.lineWrap(1);

      // Print QR code
      await SunmiPrinter.printQRCode(
        data,
        style: SunmiQrcodeStyle(
          align: SunmiPrintAlign.CENTER,
          qrcodeSize: 4,
          errorLevel: SunmiQrcodeLevel.LEVEL_H,
        ),
      );

      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.cutPaper();
    } catch (e) {
      rethrow;
    }
  }

  /// Format DateTime for printing
  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
