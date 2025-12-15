import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

/// Platform-agnostic Bluetooth printer controller interface.
///
/// The UI and services depend only on this contract.
/// Concrete implementations are:
/// - [AndroidBluetoothPrinterController] for Android
/// - [IosBluetoothPrinterController] for iOS
abstract class BluetoothPrinterController {
  bool get isBluetoothOn;
  bool get isConnected;
  bool get isScanning;
  PrinterDevice? get connectedDevice;

  Stream<List<PrinterDevice>> get scanResults;
  Stream<BTStatus> get connectState;

  Future<bool> checkConnectionWithRetry({int maxRetries = 3});
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)});
  Future<void> stopScan();
  Future<bool> connect(PrinterDevice device);
  Future<void> disconnect();
  Future<void> write(Uint8List data);

  void initListeners({
    Function(PrinterDevice)? onConnected,
    Function()? onDisconnected,
  });

  void dispose();
}

/// Base implementation shared between Android and iOS controllers.
abstract class _BaseBluetoothPrinterController
    implements BluetoothPrinterController {
  StreamSubscription<PrinterDevice>? _scanSubscription;
  StreamSubscription<BTStatus>? _stateSubscription;
  PrinterDevice? _connectedDevice;
  bool _isScanning = false;
  bool _isConnected = false;
  final List<PrinterDevice> _scannedDevices = [];

  /// Whether discovery/connection should use BLE.
  ///
  /// Many Android ESC/POS printers use classic Bluetooth (SPP),
  /// while on iOS some devices may expose BLE characteristics.
  bool get useBle;

  @override
  bool get isBluetoothOn {
    // Package does not expose a direct getter; rely on state stream.
    return true;
  }

  @override
  bool get isConnected => _isConnected;

  @override
  bool get isScanning => _isScanning;

  @override
  PrinterDevice? get connectedDevice => _connectedDevice;

  @override
  Stream<List<PrinterDevice>> get scanResults {
    final controller = StreamController<List<PrinterDevice>>();
    _scanSubscription?.cancel();

    _scanSubscription = PrinterManager.instance
        .discovery(type: PrinterType.bluetooth, isBle: useBle)
        .listen(
      (device) {
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

  @override
  Stream<BTStatus> get connectState => PrinterManager.instance.stateBluetooth;

  @override
  Future<bool> checkConnectionWithRetry({int maxRetries = 3}) async {
    const delays = [300, 500, 800]; // milliseconds

    for (int i = 0; i < maxRetries; i++) {
      if (i > 0) {
        await Future.delayed(Duration(milliseconds: delays[i - 1]));
      }
      if (_isConnected) {
        return true;
      }
    }

    return _isConnected;
  }

  @override
  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      _isScanning = true;
      _scannedDevices.clear();

      PrinterManager.instance
          .discovery(type: PrinterType.bluetooth, isBle: useBle)
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

  @override
  Future<void> stopScan() async {
    try {
      await _scanSubscription?.cancel();
      _scanSubscription = null;
      _isScanning = false;
    } catch (e) {
      _isScanning = false;
      rethrow;
    }
  }

  @override
  Future<bool> connect(PrinterDevice device) async {
    try {
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
          isBle: useBle,
          autoConnect: false,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

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

  @override
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

  @override
  Future<void> write(Uint8List data) async {
    try {
      if (data.isEmpty) {
        throw Exception('Cannot send empty data to printer');
      }

      await PrinterManager.instance.send(
        type: PrinterType.bluetooth,
        bytes: data.toList(),
      );
    } catch (e) {
      debugPrint('Error writing to printer: $e');
      rethrow;
    }
  }

  @override
  void initListeners({
    Function(PrinterDevice)? onConnected,
    Function()? onDisconnected,
  }) {
    _stateSubscription?.cancel();
    _stateSubscription = PrinterManager.instance.stateBluetooth.listen(
      (status) {
        debugPrint('Bluetooth state: $status');
        switch (status) {
          case BTStatus.connected:
            _isConnected = true;
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
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _stateSubscription?.cancel();
    _scannedDevices.clear();
    _connectedDevice = null;
    _isScanning = false;
    _isConnected = false;
  }
}

/// Android implementation – uses classic Bluetooth (SPP) by default.
class AndroidBluetoothPrinterController extends _BaseBluetoothPrinterController {
  @override
  bool get useBle => false;
}

/// iOS implementation – separated for future iOS-specific tuning.
class IosBluetoothPrinterController extends _BaseBluetoothPrinterController {
  @override
  bool get useBle => false;
}

