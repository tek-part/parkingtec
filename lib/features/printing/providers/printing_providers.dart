import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/printing/controllers/bluetooth_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/sunmi_printer_controller.dart';
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
final bluetoothPrinterControllerProvider =
    Provider<BluetoothPrinterController>((ref) {
  final controller = BluetoothPrinterController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

/// Sunmi Printer Controller Provider
final sunmiPrinterControllerProvider = Provider<SunmiPrinterController>((ref) {
  return SunmiPrinterController();
});

/// Printing Service Provider
final printingServiceProvider = Provider<PrintingService>((ref) {
  return PrintingService(
    bluetoothController: ref.read(bluetoothPrinterControllerProvider),
    sunmiController: ref.read(sunmiPrinterControllerProvider),
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
