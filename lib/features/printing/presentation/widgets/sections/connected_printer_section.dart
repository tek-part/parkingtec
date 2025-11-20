import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import '../connection/connected_printer_card.dart';

/// Widget section للطابعة المتصلة
class ConnectedPrinterSection extends ConsumerWidget {
  const ConnectedPrinterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printerType = ref.watch(printerTypeProvider);

    if (printerType == PrinterType.bluetooth) {
      final bluetoothController = ref.watch(bluetoothPrinterControllerProvider);
      final isConnected = bluetoothController.isConnected;
      final connectedDevice = bluetoothController.connectedDevice;

      if (!isConnected || connectedDevice == null) {
        return const SizedBox.shrink();
      }

      return ConnectedPrinterCard(
        connectedDevice: connectedDevice,
        onDisconnect: () async {
          try {
            await bluetoothController.disconnect();
          } catch (e) {
            // Handle error
          }
        },
      );
    }

    // Sunmi doesn't show connected device card
    return const SizedBox.shrink();
  }
}
