import 'dart:async';
import 'dart:typed_data';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';

/// Bluetooth Printer Controller
/// Simple controller for bluetooth_print_plus package
class BluetoothPrinterController {
  StreamSubscription<List<BluetoothDevice>>? _scanSubscription;
  StreamSubscription<ConnectState>? _connectSubscription;
  BluetoothDevice? _connectedDevice;
  bool _isScanning = false;

  /// Check if Bluetooth is on
  bool get isBluetoothOn {
    try {
      return BluetoothPrintPlus.isBlueOn;
    } catch (e) {
      // Handle any exceptions and return false
      return false;
    }
  }

  /// Check if connected
  /// Note: BluetoothPrintPlus.isConnected may return null in some edge cases
  /// during connection/disconnection transitions, so we handle it safely
  bool get isConnected {
    try {
      // Use dynamic to catch potential null values that linter doesn't detect
      final dynamic value = BluetoothPrintPlus.isConnected;
      if (value == null) {
        return false;
      }
      return value as bool;
    } catch (e) {
      // Handle any exceptions (including type errors) and return false
      return false;
    }
  }

  /// Check if scanning
  bool get isScanning => _isScanning;

  /// Get connected device
  BluetoothDevice? get connectedDevice => _connectedDevice;

  /// Stream of scan results
  Stream<List<BluetoothDevice>> get scanResults =>
      BluetoothPrintPlus.scanResults;

  /// Stream of connection state
  Stream<ConnectState> get connectState => BluetoothPrintPlus.connectState;

  /// Start scanning for devices
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      _isScanning = true;
      await BluetoothPrintPlus.startScan(timeout: timeout);
      // Delay to allow Activity to stabilize after permission request
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _isScanning = false;
      rethrow;
    }
  }

  /// Stop scanning
  Future<void> stopScan() async {
    try {
      await BluetoothPrintPlus.stopScan();
      _isScanning = false;
    } catch (e) {
      _isScanning = false;
      rethrow;
    }
  }

  /// Connect to a device
  Future<bool> connect(BluetoothDevice device) async {
    try {
      final dynamic result = await BluetoothPrintPlus.connect(device);
      // Handle null case - treat as false
      final connected = result == true;
      if (connected) {
        _connectedDevice = device;
      }
      return connected;
    } catch (e) {
      _connectedDevice = null;
      rethrow;
    }
  }

  /// Disconnect from current device
  Future<void> disconnect() async {
    try {
      await BluetoothPrintPlus.disconnect();
      _connectedDevice = null;
    } catch (e) {
      _connectedDevice = null;
      rethrow;
    }
  }

  /// Write data to printer
  Future<void> write(Uint8List data) async {
    try {
      await BluetoothPrintPlus.write(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize listeners
  void initListeners({
    Function(BluetoothDevice)? onConnected,
    Function()? onDisconnected,
  }) {
    _connectSubscription?.cancel();
    _connectSubscription = BluetoothPrintPlus.connectState.listen((state) {
      switch (state) {
        case ConnectState.connected:
          // Get connected device
          _getConnectedDevice();
          if (_connectedDevice != null) {
            onConnected?.call(_connectedDevice!);
          }
          break;
        case ConnectState.disconnected:
          _connectedDevice = null;
          onDisconnected?.call();
          break;
      }
    });
  }

  /// Get connected device
  Future<void> _getConnectedDevice() async {
    try {
      // Try to get connected device from scan results
      final devices = await BluetoothPrintPlus.scanResults.first.timeout(
        const Duration(seconds: 1),
      );
      // Safely check connection status
      bool isConnected = false;
      try {
        final dynamic value = BluetoothPrintPlus.isConnected;
        if (value == null) {
          isConnected = false;
        } else {
          isConnected = value as bool;
        }
      } catch (e) {
        isConnected = false;
      }
      if (devices.isNotEmpty && isConnected) {
        // Find connected device
        for (final device in devices) {
          if (device.address == _connectedDevice?.address) {
            _connectedDevice = device;
            return;
          }
        }
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Dispose resources
  void dispose() {
    _scanSubscription?.cancel();
    _connectSubscription?.cancel();
    _connectedDevice = null;
    _isScanning = false;
  }
}
