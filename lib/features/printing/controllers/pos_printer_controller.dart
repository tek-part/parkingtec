import 'dart:typed_data';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/printing/controllers/bluetooth_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/sunmi_printer_controller.dart';
import 'package:parkingtec/features/printing/core/utils/paper_preset.dart';
import 'package:parkingtec/features/printing/services/pos_printer_service.dart';

/// POS Printer Controller
/// Validates connection and delegates to PosPrinterService
class PosPrinterController {
  final PosPrinterService _service;
  final BluetoothPrinterController _bluetoothController;
  final SunmiPrinterController _sunmiController;

  PaperPreset _paperWidth = PaperPreset.mm80;
  String _fontFamily = 'Cairo';
  int _sliceHeight = 900;

  PosPrinterController({
    required PosPrinterService service,
    required BluetoothPrinterController bluetoothController,
    required SunmiPrinterController sunmiController,
  })  : _service = service,
        _bluetoothController = bluetoothController,
        _sunmiController = sunmiController;

  /// Update settings
  void updateSettings({
    PaperPreset? paperWidth,
    String? fontFamily,
    int? sliceHeight,
  }) {
    if (paperWidth != null) _paperWidth = paperWidth;
    if (fontFamily != null) _fontFamily = fontFamily;
    if (sliceHeight != null) _sliceHeight = sliceHeight;
  }

  /// Check if printer is connected (with retry)
  Future<bool> checkConnection() async {
    // Try Sunmi first
    if (_sunmiController.isInitialized) {
      return true;
    }

    // Try Bluetooth with retry
    return await _bluetoothController.checkConnectionWithRetry();
  }

  /// Print entry ticket
  Future<bool> printEntryTicket({
    required Invoice invoice,
    required AppConfig appConfig,
    PaperPreset? paperWidth,
    String? fontFamily,
    int? sliceHeight,
    int feedLines = 2,
    Function(double progress)? onRenderingProgress,
    Function(double progress)? onSendingProgress,
    bool Function()? shouldCancel,
  }) async {
    // Check connection with retry
    final isConnected = await checkConnection();
    if (!isConnected) {
      return false;
    }

    final finalPaperWidth = paperWidth ?? _paperWidth;
    final finalFontFamily = fontFamily ?? _fontFamily;
    final finalSliceHeight = sliceHeight ?? _sliceHeight;

    // Determine printer type
    final isSunmi = _sunmiController.isInitialized;
    final isBluetooth = await _bluetoothController.checkConnectionWithRetry();

    if (isSunmi) {
      await _service.printTicket(
        invoice: invoice,
        appConfig: appConfig,
        paper: finalPaperWidth,
        isExitReceipt: false,
        fontFamily: finalFontFamily,
        sliceHeight: finalSliceHeight,
        feedLines: feedLines,
        onRenderingProgress: onRenderingProgress,
        onSendingProgress: onSendingProgress,
        shouldCancel: shouldCancel,
        isSunmi: true,
        sunmiController: _sunmiController,
        bluetoothController: null,
      );
      return true;
    } else if (isBluetooth) {
      await _service.printTicket(
        invoice: invoice,
        appConfig: appConfig,
        paper: finalPaperWidth,
        isExitReceipt: false,
        fontFamily: finalFontFamily,
        sliceHeight: finalSliceHeight,
        feedLines: feedLines,
        onRenderingProgress: onRenderingProgress,
        onSendingProgress: onSendingProgress,
        shouldCancel: shouldCancel,
        isSunmi: false,
        sunmiController: null,
        bluetoothController: _bluetoothController,
      );
      return true;
    }

    return false;
  }

  /// Print exit receipt
  Future<bool> printExitReceipt({
    required Invoice invoice,
    required AppConfig appConfig,
    PaperPreset? paperWidth,
    String? fontFamily,
    int? sliceHeight,
    int feedLines = 2,
    Function(double progress)? onRenderingProgress,
    Function(double progress)? onSendingProgress,
    bool Function()? shouldCancel,
  }) async {
    // Check connection with retry
    final isConnected = await checkConnection();
    if (!isConnected) {
      return false;
    }

    final finalPaperWidth = paperWidth ?? _paperWidth;
    final finalFontFamily = fontFamily ?? _fontFamily;
    final finalSliceHeight = sliceHeight ?? _sliceHeight;

    // Determine printer type
    final isSunmi = _sunmiController.isInitialized;
    final isBluetooth = await _bluetoothController.checkConnectionWithRetry();

    if (isSunmi) {
      await _service.printTicket(
        invoice: invoice,
        appConfig: appConfig,
        paper: finalPaperWidth,
        isExitReceipt: true,
        fontFamily: finalFontFamily,
        sliceHeight: finalSliceHeight,
        feedLines: feedLines,
        onRenderingProgress: onRenderingProgress,
        onSendingProgress: onSendingProgress,
        shouldCancel: shouldCancel,
        isSunmi: true,
        sunmiController: _sunmiController,
        bluetoothController: null,
      );
      return true;
    } else if (isBluetooth) {
      await _service.printTicket(
        invoice: invoice,
        appConfig: appConfig,
        paper: finalPaperWidth,
        isExitReceipt: true,
        fontFamily: finalFontFamily,
        sliceHeight: finalSliceHeight,
        feedLines: feedLines,
        onRenderingProgress: onRenderingProgress,
        onSendingProgress: onSendingProgress,
        shouldCancel: shouldCancel,
        isSunmi: false,
        sunmiController: null,
        bluetoothController: _bluetoothController,
      );
      return true;
    }

    return false;
  }

  /// Preview ticket
  Future<List<Uint8List>> previewTicket({
    required Invoice invoice,
    required AppConfig appConfig,
    PaperPreset? paperWidth,
    String? fontFamily,
    int? sliceHeight,
    bool isExitReceipt = false,
    Function(double progress)? onProgress,
  }) async {
    final finalPaperWidth = paperWidth ?? _paperWidth;
    final finalFontFamily = fontFamily ?? _fontFamily;
    final finalSliceHeight = sliceHeight ?? _sliceHeight;

    return await _service.previewTicket(
      invoice: invoice,
      appConfig: appConfig,
      paper: finalPaperWidth,
      isExitReceipt: isExitReceipt,
      fontFamily: finalFontFamily,
      sliceHeight: finalSliceHeight,
      onProgress: onProgress,
    );
  }
}

