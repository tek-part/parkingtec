import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parkingtec/features/printing/controllers/bluetooth_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/pos_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/sunmi_printer_controller.dart';
import 'package:parkingtec/features/printing/services/pos_printer_service.dart';
import 'package:parkingtec/features/printing/services/printing_service.dart';
import 'package:parkingtec/features/printing/usecases/print_invoice_usecase.dart';
import 'package:parkingtec/features/printing/usecases/reprint_invoice_usecase.dart';

/// Printer Type Enum
enum PrinterType {
  sunmi,
  bluetooth,
}

/// Printer Type Provider
final printerTypeProvider = StateProvider<PrinterType>((ref) {
  return PrinterType.bluetooth; // Default to bluetooth
});

/// Bluetooth Printer Controller Provider
///
/// Returns a platform-specific implementation while keeping a single
/// interface for the rest of the app.
final bluetoothPrinterControllerProvider =
    Provider<BluetoothPrinterController>((ref) {
  final controller = Platform.isIOS
      ? IosBluetoothPrinterController()
      : AndroidBluetoothPrinterController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// Sunmi Printer Controller Provider
final sunmiPrinterControllerProvider = Provider<SunmiPrinterController>((ref) {
  return SunmiPrinterController();
});

/// POS Printer Service Provider
final posPrinterServiceProvider = Provider<PosPrinterService>((ref) {
  return const PosPrinterService();
});

/// POS Printer Controller Provider
final posPrinterControllerProvider = Provider<PosPrinterController>((ref) {
  return PosPrinterController(
    service: ref.read(posPrinterServiceProvider),
    bluetoothController: ref.read(bluetoothPrinterControllerProvider),
    sunmiController: ref.read(sunmiPrinterControllerProvider),
  );
});

/// Printing Service Provider
final printingServiceProvider = Provider<PrintingService>((ref) {
  return PrintingService(
    posController: ref.read(posPrinterControllerProvider),
    bluetoothController: ref.read(bluetoothPrinterControllerProvider),
  );
});

/// Print Invoice Use Case Provider
final printInvoiceUseCaseProvider = Provider<PrintInvoiceUseCase>((ref) {
  return PrintInvoiceUseCase(ref.read(printingServiceProvider));
});

/// Reprint Invoice Use Case Provider
final reprintInvoiceUseCaseProvider = Provider<ReprintInvoiceUseCase>((ref) {
  return ReprintInvoiceUseCase(ref.read(printingServiceProvider));
});

/// Print Invoice On Create Use Case (alias)
final printInvoiceOnCreateUseCaseProvider = Provider<PrintInvoiceUseCase>((ref) {
  return ref.read(printInvoiceUseCaseProvider);
});

/// Print Invoice On Complete Use Case (alias)
final printInvoiceOnCompleteUseCaseProvider = Provider<PrintInvoiceUseCase>((ref) {
  return ref.read(printInvoiceUseCaseProvider);
});
