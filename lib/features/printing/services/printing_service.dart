import 'package:flutter/foundation.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/printing/controllers/bluetooth_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/pos_printer_controller.dart';
import 'package:parkingtec/features/printing/core/utils/paper_preset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

/// Printing Service
/// Coordinates printing and loads settings from SharedPreferences
class PrintingService {
  final PosPrinterController _posController;
  final BluetoothPrinterController _bluetoothController;

  PrintingService({
    required PosPrinterController posController,
    required BluetoothPrinterController bluetoothController,
  }) : _posController = posController,
       _bluetoothController = bluetoothController;

  /// Check connection with retry
  Future<bool> checkConnection() async {
    final isConnected = await _posController.checkConnection();

    // If connected, try to auto-detect paper size
    if (isConnected) {
      await _autoDetectAndSavePaperSize();
    }

    return isConnected;
  }

  /// Auto-detect paper size from connected printer and save it
  Future<void> _autoDetectAndSavePaperSize() async {
    try {
      final connectedDevice = await getConnectedDevice();
      if (connectedDevice != null) {
        final detectedSize = _detectPaperSizeFromName(connectedDevice.name);
        if (detectedSize != null) {
          final prefs = await SharedPreferences.getInstance();
          final currentSetting = prefs.getString('printer_paper_width');

          // Only auto-save if there's no manual setting
          if (currentSetting == null) {
            await prefs.setString(
              'printer_paper_width',
              detectedSize.toString(),
            );
            _posController.updateSettings(paperWidth: detectedSize);
            debugPrint(
              '✅ Auto-detected paper size: ${detectedSize.name} from printer: ${connectedDevice.name}',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error auto-detecting paper size: $e');
    }
  }

  /// Get connected device
  Future<PrinterDevice?> getConnectedDevice() async {
    return _bluetoothController.connectedDevice;
  }

  /// Try to detect paper size from printer name
  /// Returns null if cannot detect
  PaperPreset? _detectPaperSizeFromName(String? printerName) {
    if (printerName == null || printerName.isEmpty) return null;

    final name = printerName.toLowerCase();

    // Check for 110mm indicators first (before 80mm to avoid false matches)
    if (name.contains('110') ||
        name.contains('110mm') ||
        name.contains('w110')) {
      return PaperPreset.mm110;
    }

    // Check for 80mm indicators
    if (name.contains('80') ||
        name.contains('80mm') ||
        name.contains('wide') ||
        name.contains('w80')) {
      return PaperPreset.mm80;
    }

    // Check for 58mm indicators
    if (name.contains('58') ||
        name.contains('58mm') ||
        name.contains('narrow') ||
        name.contains('w58')) {
      return PaperPreset.mm58;
    }

    return null; // Cannot detect
  }

  /// Load settings from SharedPreferences
  /// Auto-detects paper size from printer name if manual setting is not available or set to "auto"
  Future<Map<String, dynamic>> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final paperWidthStr = prefs.getString('printer_paper_width');
    final savedSliceHeight = prefs.getInt('printer_slice_height') ?? 900;
    final fontFamily = prefs.getString('printer_font_family') ?? 'Cairo';

    PaperPreset finalPaperWidth = PaperPreset.mm80; // Default

    // Check if "auto" is selected or no setting exists
    if (paperWidthStr == null || paperWidthStr == 'auto') {
      // Try auto-detection from printer name first
      final connectedDevice = await getConnectedDevice();
      if (connectedDevice != null) {
        final detectedSize = _detectPaperSizeFromName(connectedDevice.name);
        if (detectedSize != null) {
          finalPaperWidth = detectedSize;
        } else {
          // If cannot detect from name, use maximum width (110mm) to take full printer width
          finalPaperWidth = PaperPreset.mm110;
        }
      } else {
        // No device connected, use maximum width (110mm) to take full printer width
        finalPaperWidth = PaperPreset.mm110;
      }
    } else {
      // Manual setting - try to load it
      try {
        finalPaperWidth = PaperPreset.values.firstWhere(
          (e) => e.toString() == paperWidthStr,
          orElse: () => PaperPreset.mm80,
        );
      } catch (e) {
        // If manual setting is invalid, try auto-detection
        final connectedDevice = await getConnectedDevice();
        if (connectedDevice != null) {
          final detectedSize = _detectPaperSizeFromName(connectedDevice.name);
          if (detectedSize != null) {
            finalPaperWidth = detectedSize;
          }
        }
      }
    }

    return {
      'paperWidth': finalPaperWidth,
      'sliceHeight': savedSliceHeight,
      'fontFamily': fontFamily,
    };
  }

  /// Print entry ticket (internal - returns bool)
  Future<bool> printEntryTicket({
    required Invoice invoice,
    required AppConfig appConfig,
    PaperPreset? paperWidth,
    int? sliceHeight,
    Function(double progress)? onRenderingProgress,
    Function(double progress)? onSendingProgress,
    bool Function()? shouldCancel,
  }) async {
    try {
      // Load settings
      final settings = await _loadSettings();
      final finalPaperWidth =
          paperWidth ?? settings['paperWidth'] as PaperPreset;
      final finalSliceHeight = sliceHeight ?? settings['sliceHeight'] as int;

      final finalFontFamily = settings['fontFamily'] as String;

      return await _posController.printEntryTicket(
        invoice: invoice,
        appConfig: appConfig,
        paperWidth: finalPaperWidth,
        fontFamily: finalFontFamily,
        sliceHeight: finalSliceHeight,
        feedLines: 2,
        onRenderingProgress: onRenderingProgress,
        onSendingProgress: onSendingProgress,
        shouldCancel: shouldCancel,
      );
    } catch (e) {
      return false;
    }
  }

  /// Print exit receipt (internal - returns bool)
  Future<bool> printExitReceipt({
    required Invoice invoice,
    required AppConfig appConfig,
    PaperPreset? paperWidth,
    int? sliceHeight,
    Function(double progress)? onRenderingProgress,
    Function(double progress)? onSendingProgress,
    bool Function()? shouldCancel,
  }) async {
    try {
      // Load settings
      final settings = await _loadSettings();
      final finalPaperWidth =
          paperWidth ?? settings['paperWidth'] as PaperPreset;
      final finalSliceHeight = sliceHeight ?? settings['sliceHeight'] as int;
      final finalFontFamily = settings['fontFamily'] as String;

      return await _posController.printExitReceipt(
        invoice: invoice,
        appConfig: appConfig,
        paperWidth: finalPaperWidth,
        fontFamily: finalFontFamily,
        sliceHeight: finalSliceHeight,
        feedLines: 2,
        onRenderingProgress: onRenderingProgress,
        onSendingProgress: onSendingProgress,
        shouldCancel: shouldCancel,
      );
    } catch (e) {
      return false;
    }
  }

  /// Preview ticket
  Future<List<Uint8List>> previewTicket({
    required Invoice invoice,
    required AppConfig appConfig,
    PaperPreset? paperWidth,
    int? sliceHeight,
    bool isExitReceipt = false,
  }) async {
    try {
      // Load settings
      final settings = await _loadSettings();
      final finalPaperWidth =
          paperWidth ?? settings['paperWidth'] as PaperPreset;
      final finalSliceHeight = sliceHeight ?? settings['sliceHeight'] as int;

      final finalFontFamily = settings['fontFamily'] as String;

      return await _posController.previewTicket(
        invoice: invoice,
        appConfig: appConfig,
        paperWidth: finalPaperWidth,
        fontFamily: finalFontFamily,
        sliceHeight: finalSliceHeight,
        isExitReceipt: isExitReceipt,
      );
    } catch (e) {
      return [];
    }
  }

  /// Update settings
  /// If paperWidth is null, tries to auto-detect from connected printer
  Future<void> updateSettings({
    PaperPreset? paperWidth,
    String? fontFamily,
    int? sliceHeight,
    bool? useAuto, // New parameter to indicate auto mode
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (useAuto == true) {
      // Set to auto mode
      await prefs.setString('printer_paper_width', 'auto');
      // Try auto-detection and update controller
      final connectedDevice = await getConnectedDevice();
      PaperPreset selectedWidth;
      if (connectedDevice != null) {
        final detectedSize = _detectPaperSizeFromName(connectedDevice.name);
        if (detectedSize != null) {
          selectedWidth = detectedSize;
        } else {
          // If cannot detect from name, use maximum width (110mm) to take full printer width
          selectedWidth = PaperPreset.mm110;
        }
      } else {
        // No device connected, use maximum width (110mm) to take full printer width
        selectedWidth = PaperPreset.mm110;
      }
      _posController.updateSettings(paperWidth: selectedWidth);
    } else if (paperWidth != null) {
      // Manual setting - save it
      await prefs.setString('printer_paper_width', paperWidth.toString());
      _posController.updateSettings(paperWidth: paperWidth);
    }

    if (fontFamily != null) {
      await prefs.setString('printer_font_family', fontFamily);
      _posController.updateSettings(fontFamily: fontFamily);
    }

    if (sliceHeight != null) {
      await prefs.setInt('printer_slice_height', sliceHeight);
      _posController.updateSettings(sliceHeight: sliceHeight);
    }
  }
}
