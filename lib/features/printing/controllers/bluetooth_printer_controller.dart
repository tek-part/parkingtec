import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

/// Bluetooth Printer Controller
/// Uses flutter_pos_printer_platform_image_3 package
class BluetoothPrinterController {
  StreamSubscription<PrinterDevice>? _scanSubscription;
  StreamSubscription<BTStatus>? _stateSubscription;
  PrinterDevice? _connectedDevice;
  bool _isScanning = false;
  bool _isConnected = false;
  final List<PrinterDevice> _scannedDevices = [];

  /// Check if Bluetooth is on
  /// Note: flutter_pos_printer_platform_image_3 doesn't have direct isBlueOn
  /// We'll monitor state stream instead
  bool get isBluetoothOn {
    // The new package doesn't expose this directly
    // Return true as default - state stream will handle actual status
    return true;
  }

  /// Check if connected
  bool get isConnected => _isConnected;

  /// Check connection with retry mechanism
  /// Handles false negatives where connection check returns false even when connected
  /// Uses exponential backoff: 300ms, 500ms, 800ms delays
  Future<bool> checkConnectionWithRetry({int maxRetries = 3}) async {
    const delays = [300, 500, 800]; // milliseconds

    for (int i = 0; i < maxRetries; i++) {
      // Wait before checking (allow native listeners to stabilize)
      if (i > 0) {
        await Future.delayed(Duration(milliseconds: delays[i - 1]));
      }

      if (_isConnected) {
        return true;
      }
    }

    return _isConnected;
  }

  /// Check if scanning
  bool get isScanning => _isScanning;

  /// Get connected device
  PrinterDevice? get connectedDevice => _connectedDevice;

  /// Stream of scan results
  /// Returns stream of individual devices (new package emits one at a time)
  Stream<List<PrinterDevice>> get scanResults {
    // Create a stream that collects devices
    final controller = StreamController<List<PrinterDevice>>();
    _scanSubscription?.cancel();

    _scanSubscription = PrinterManager.instance
        .discovery(type: PrinterType.bluetooth, isBle: false)
        .listen(
          (device) {
            // Add device to list if not already present
            if (!_scannedDevices.any((d) => d.address == device.address)) {
              _scannedDevices.add(device);
              controller.add(List.from(_scannedDevices));
            }
          },
          onError: (error) {
            debugPrint('Scan error: $error');
            controller.addError(error);
          },
          onDone: () {
            controller.close();
          },
          cancelOnError: false,
        );

    return controller.stream;
  }

  /// Stream of connection state
  Stream<BTStatus> get connectState => PrinterManager.instance.stateBluetooth;

  /// Start scanning for devices
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      _isScanning = true;
      _scannedDevices.clear();

      // Start discovery - it returns a stream that we'll listen to in scanResults
      // The discovery stream will emit devices as they're found
      // We don't need to await it, just start it
      PrinterManager.instance
          .discovery(type: PrinterType.bluetooth, isBle: false)
          .listen(
            (device) {
              if (!_scannedDevices.any((d) => d.address == device.address)) {
                _scannedDevices.add(device);
              }
            },
            onError: (error) {
              debugPrint('Discovery error: $error');
              _isScanning = false;
            },
          );

      // Stop scanning after timeout
      Future.delayed(timeout, () {
        if (_isScanning) {
          stopScan();
        }
      });
    } catch (e) {
      _isScanning = false;
      rethrow;
    }
  }

  /// Stop scanning
  Future<void> stopScan() async {
    try {
      _scanSubscription?.cancel();
      _scanSubscription = null;
      _isScanning = false;
    } catch (e) {
      _isScanning = false;
      rethrow;
    }
  }

  /// Connect to a device
  Future<bool> connect(PrinterDevice device) async {
    try {
      if (device.address == null) {
        debugPrint('connect: Device address is null');
        return false;
      }

      // Connect using BluetoothPrinterInput
      final address = device.address;
      if (address == null) {
        debugPrint('connect: Device address is null');
        return false;
      }

      await PrinterManager.instance.connect(
        type: PrinterType.bluetooth,
        model: BluetoothPrinterInput(
          name: device.name,
          address: address,
          isBle: false, // Use classic Bluetooth, not BLE
          autoConnect: false,
        ),
      );

      // Wait a bit for connection to establish
      await Future.delayed(const Duration(milliseconds: 500));

      // Check connection status from state stream
      // The state stream will update _isConnected via initListeners
      if (_isConnected) {
        _connectedDevice = device;
        return true;
      } else {
        _connectedDevice = null;
        return false;
      }
    } catch (e) {
      debugPrint('connect error: $e');
      _connectedDevice = null;
      _isConnected = false;
      return false;
    }
  }

  /// Disconnect from current device
  Future<void> disconnect() async {
    try {
      await PrinterManager.instance.disconnect(type: PrinterType.bluetooth);
      _connectedDevice = null;
      _isConnected = false;
    } catch (e) {
      _connectedDevice = null;
      _isConnected = false;
      rethrow;
    }
  }

  /// Write data to printer
  Future<void> write(Uint8List data) async {
    try {
      // Ensure data is not empty
      if (data.isEmpty) {
        throw Exception('Cannot send empty data to printer');
      }

      // Convert to List<int> and send
      await PrinterManager.instance.send(
        type: PrinterType.bluetooth,
        bytes: data.toList(),
      );
    } catch (e) {
      debugPrint('Error writing to printer: $e');
      rethrow;
    }
  }

  /// Initialize listeners
  void initListeners({
    Function(PrinterDevice)? onConnected,
    Function()? onDisconnected,
  }) {
    _stateSubscription?.cancel();
    _stateSubscription = PrinterManager.instance.stateBluetooth.listen((
      status,
    ) {
      debugPrint('Bluetooth state: $status');
      switch (status) {
        case BTStatus.connected:
          _isConnected = true;
          // Try to get connected device from scanned devices
          if (_connectedDevice != null) {
            onConnected?.call(_connectedDevice!);
          }
          break;
        case BTStatus.none:
          _isConnected = false;
          _connectedDevice = null;
          onDisconnected?.call();
          break;
        default:
          // Other states like connecting, etc.
          break;
      }
    });
  }

  /// Dispose resources
  void dispose() {
    _scanSubscription?.cancel();
    _stateSubscription?.cancel();
    _scannedDevices.clear();
    _connectedDevice = null;
    _isScanning = false;
    _isConnected = false;
  }
}
