import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import '../discovery/printer_discovery_widget.dart';

/// Widget section للبحث عن الطابعات
class PrinterDiscoverySection extends ConsumerWidget {
  const PrinterDiscoverySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printerType = ref.watch(printerTypeProvider);

    // Only show discovery for Bluetooth printers
    if (printerType != PrinterType.bluetooth) {
      return const SizedBox.shrink();
    }

    final bluetoothController = ref.watch(bluetoothPrinterControllerProvider);
    final isScanning = bluetoothController.isScanning;
    final isConnected = bluetoothController.isConnected;
    final connectedDevice = bluetoothController.connectedDevice;

    return PrinterDiscoveryWidget(
      scanResults$: bluetoothController.scanResults,
      isScanning: isScanning,
      connectedDevice: connectedDevice,
      isConnected: isConnected,
      isConnecting: false, // Not tracking connecting state in simple version
      onStartScan: () async {
        try {
          await bluetoothController.startScan();
        } catch (e) {
          // Handle error
        }
      },
      onStopScan: () async {
        try {
          await bluetoothController.stopScan();
        } catch (e) {
          // Handle error
        }
      },
      onConnectToDevice: (device) async {
        try {
          await bluetoothController.connect(device);
        } catch (e) {
          // Handle error
        }
      },
    );
  }
}
