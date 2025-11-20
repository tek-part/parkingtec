import 'dart:typed_data';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

/// Sunmi Printer Controller
/// Simple controller for sunmi_printer_plus package
class SunmiPrinterController {
  bool _isInitialized = false;

  /// Check if printer is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize printer
  Future<void> initPrinter() async {
    try {
      // Sunmi printer doesn't need explicit init in v4.1.1
      // But we can check if printer is available
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  /// Print text
  Future<void> printText(
    String text, {
    bool bold = false,
    SunmiPrintAlign align = SunmiPrintAlign.LEFT,
    int fontSize = 24, // Default font size
  }) async {
    try {
      await SunmiPrinter.printText(
        text,
        style: SunmiTextStyle(
          bold: bold,
          align: align,
          fontSize: fontSize,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Print QR code
  Future<void> printQRCode(
    String data, {
    int qrcodeSize = 3,
    SunmiQrcodeLevel errorLevel = SunmiQrcodeLevel.LEVEL_H,
  }) async {
    try {
      await SunmiPrinter.printQRCode(
        data,
        style: SunmiQrcodeStyle(
          qrcodeSize: qrcodeSize,
          errorLevel: errorLevel,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Print barcode (Note: barcode printing may not be available in all versions)
  Future<void> printBarcode(
    String data,
    SunmiBarcodeType type, {
    int height = 100,
    int width = 2,
    SunmiBarcodeTextPos textPos = SunmiBarcodeTextPos.TEXT_UNDER,
  }) async {
    // Barcode printing may not be available in current version
    // This is a placeholder for future implementation
    throw UnimplementedError('Barcode printing not yet implemented');
  }

  /// Print image
  Future<void> printImage(Uint8List imageBytes) async {
    try {
      await SunmiPrinter.printImage(imageBytes);
    } catch (e) {
      rethrow;
    }
  }

  /// Line wrap (jump lines)
  Future<void> lineWrap(int lines) async {
    try {
      await SunmiPrinter.lineWrap(lines);
    } catch (e) {
      rethrow;
    }
  }

  /// Cut paper
  Future<void> cutPaper() async {
    try {
      await SunmiPrinter.cutPaper();
    } catch (e) {
      rethrow;
    }
  }

  /// Print ESC/POS commands
  Future<void> printEscPos(Uint8List data) async {
    try {
      await SunmiPrinter.printEscPos(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get printer serial number (if available)
  Future<String?> getSerialNumber() async {
    // Serial number may not be available in current version
    return null;
  }

  /// Get printer version (if available)
  Future<String?> getPrinterVersion() async {
    // Printer version may not be available in current version
    return null;
  }

  /// Get paper size (if available) (0: 80mm, 1: 58mm)
  Future<int?> getPaperSize() async {
    // Paper size may not be available in current version
    return null;
  }

  /// Open cash drawer
  Future<void> openDrawer() async {
    try {
      await SunmiDrawer.openDrawer();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if cash drawer is open
  Future<bool> isDrawerOpen() async {
    try {
      return await SunmiDrawer.isDrawerOpen();
    } catch (e) {
      return false;
    }
  }
}

