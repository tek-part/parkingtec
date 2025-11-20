import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';

/// Printer Connection Helper
/// Utility class to check printer connection status
class PrinterConnectionHelper {
  /// Check if any printer is connected
  /// Returns true if either Bluetooth or Sunmi printer is connected/initialized
  static bool isPrinterConnected(WidgetRef ref) {
    final printerType = ref.read(printerTypeProvider);
    final bluetoothController = ref.read(bluetoothPrinterControllerProvider);
    final sunmiController = ref.read(sunmiPrinterControllerProvider);

    // Check based on selected printer type
    if (printerType == PrinterType.bluetooth) {
      return bluetoothController.isConnected;
    } else if (printerType == PrinterType.sunmi) {
      return sunmiController.isInitialized;
    }

    // If no specific type selected, check both
    return bluetoothController.isConnected || sunmiController.isInitialized;
  }
}


