import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import '../connection/connection_status_widget.dart';

/// Widget section للاتصال - يعرض حالة الاتصال حسب نوع الطابعة
class ConnectionStatusSection extends ConsumerWidget {
  const ConnectionStatusSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printerType = ref.watch(printerTypeProvider);

    if (printerType == PrinterType.sunmi) {
      return _buildSunmiConnectionStatus(ref);
    } else {
      return _buildBluetoothConnectionStatus(ref);
    }
  }

  Widget _buildSunmiConnectionStatus(WidgetRef ref) {
    final sunmiController = ref.watch(sunmiPrinterControllerProvider);
    
    return ConnectionStatusWidget(
      isConnected: sunmiController.isInitialized,
      connectedDevice: null, // Sunmi doesn't have a BluetoothDevice
      onDisconnect: sunmiController.isInitialized
          ? () async {
              // Sunmi doesn't need explicit disconnect
              // Just reset initialization state
            }
          : null,
    );
  }

  Widget _buildBluetoothConnectionStatus(WidgetRef ref) {
    final bluetoothController = ref.watch(bluetoothPrinterControllerProvider);
    final isConnected = bluetoothController.isConnected;
    final connectedDevice = bluetoothController.connectedDevice;

    return ConnectionStatusWidget(
      isConnected: isConnected,
      connectedDevice: connectedDevice,
      onDisconnect: isConnected
          ? () async {
              try {
                await bluetoothController.disconnect();
              } catch (e) {
                // Handle error
              }
            }
          : null,
    );
  }
}
