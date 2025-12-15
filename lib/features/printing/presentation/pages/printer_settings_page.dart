import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart'
    hide PrinterType;
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/printing/controllers/bluetooth_printer_controller.dart';
import 'package:parkingtec/features/printing/controllers/sunmi_printer_controller.dart';
import 'package:parkingtec/features/printing/core/utils/paper_preset.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

class PrinterSettingsPage extends ConsumerStatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  ConsumerState<PrinterSettingsPage> createState() =>
      _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends ConsumerState<PrinterSettingsPage> {
  String? _selectedPaperWidth; // null or 'auto' or PaperPreset.toString()
  bool _isLoadingPaperWidth = true;

  @override
  void initState() {
    super.initState();
    _loadPaperWidthSetting();
    // Initialize listeners when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bluetoothController = ref.read(bluetoothPrinterControllerProvider);
      bluetoothController.initListeners(
        onConnected: (device) {
          if (mounted) {
            setState(() {}); // Refresh UI to show connection status
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).connectedToDevice(device.name)),
              ),
            );
          }
        },
        onDisconnected: () {
          if (mounted) {
            setState(() {}); // Refresh UI to show disconnection status
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(S.of(context).disconnected)));
          }
        },
      );
    });
  }

  Future<void> _loadPaperWidthSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final paperWidthStr = prefs.getString('printer_paper_width');
    setState(() {
      _selectedPaperWidth = paperWidthStr ?? 'auto';
      _isLoadingPaperWidth = false;
    });
  }

  Future<void> _updatePaperWidth(String? value) async {
    setState(() {
      _selectedPaperWidth = value;
    });

    final printingService = ref.read(printingServiceProvider);

    if (value == 'auto') {
      await printingService.updateSettings(useAuto: true);
    } else {
      try {
        final paperPreset = PaperPreset.values.firstWhere(
          (e) => e.toString() == value,
        );
        await printingService.updateSettings(paperWidth: paperPreset);
      } catch (e) {
        // Invalid value, revert to auto
        await printingService.updateSettings(useAuto: true);
        setState(() {
          _selectedPaperWidth = 'auto';
        });
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value == 'auto'
                ? 'Paper width set to Auto'
                : 'Paper width set to ${value?.replaceAll('PaperPreset.', '') ?? 'Auto'}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final printerType = ref.watch(printerTypeProvider);
    final bluetoothController = ref.watch(bluetoothPrinterControllerProvider);
    final sunmiController = ref.watch(sunmiPrinterControllerProvider);
    final isBlueOn = bluetoothController.isBluetoothOn;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: Text(
          s.printerSettings,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryX(context),
          ),
        ),
        backgroundColor: AppColors.background(context),
        foregroundColor: AppColors.primaryX(context),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Printer Type Selection
            _buildPrinterTypeSelector(printerType),
            SizedBox(height: 24.h),

            // Content based on selected printer type
            if (printerType == PrinterType.bluetooth) ...[
              if (!isBlueOn)
                _buildBluetoothDisabledMessage()
              else
                _buildBluetoothPrinterContent(bluetoothController),
            ] else ...[
              _buildSunmiPrinterContent(sunmiController),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrinterTypeSelector(PrinterType currentType) {
    return Card(
      color: AppColors.surface(context),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).selectPrinterType,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPrinterTypeOption(
                    S.of(context).printerTypeSunmi,
                    Icons.print,
                    PrinterType.sunmi,
                    currentType == PrinterType.sunmi,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildPrinterTypeOption(
                    S.of(context).printerTypeEscPos,
                    Icons.bluetooth,
                    PrinterType.bluetooth,
                    currentType == PrinterType.bluetooth,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrinterTypeOption(
    String title,
    IconData icon,
    PrinterType type,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        ref.read(printerTypeProvider.notifier).state = type;
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryX(context).withOpacity(0.1)
              : AppColors.card(context),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryX(context)
                : AppColors.border(context),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32.sp,
              color: isSelected
                  ? AppColors.primaryX(context)
                  : AppColors.textSecondary(context),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primaryX(context)
                    : AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothDisabledMessage() {
    return Card(
      color: AppColors.surface(context),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Icon(Icons.bluetooth_disabled, size: 64.sp, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              S.of(context).pleaseEnableBluetooth,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothPrinterContent(BluetoothPrinterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Paper Width Settings
        _buildPaperWidthSelector(),
        SizedBox(height: 16.h),

        // Connection Status - Use safe check
        _buildStatusCard(
          S.of(context).connectionStatus,
          (controller.isConnected && controller.connectedDevice != null)
              ? S.of(context).connected
              : S.of(context).notConnected,
          (controller.isConnected && controller.connectedDevice != null)
              ? Icons.check_circle
              : Icons.cancel,
          (controller.isConnected && controller.connectedDevice != null)
              ? AppColors.success
              : AppColors.error,
        ),
        SizedBox(height: 16.h),

        // Scan Button
        ElevatedButton.icon(
          onPressed: controller.isScanning
              ? null
              : () async {
                  try {
                    await controller.startScan();
                  } catch (e) {
                    if (mounted) {
                      print('scanError: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${S.of(context).scanError}: $e'),
                        ),
                      );
                    }
                  }
                },
          icon: controller.isScanning
              ? SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.search),
          label: Text(
            controller.isScanning
                ? S.of(context).scanning
                : S.of(context).scanDevices,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryX(context),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
          ),
        ),
        SizedBox(height: 16.h),

        // Scan Results
        StreamBuilder<List<PrinterDevice>>(
          stream: controller.scanResults,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).availableDevices,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 12.h),
                ...snapshot.data!.map(
                  (device) => _buildDeviceCard(device, controller),
                ),
              ],
            );
          },
        ),

        // Connected Device Info
        if (controller.connectedDevice != null) ...[
          SizedBox(height: 16.h),
          _buildStatusCard(
            S.of(context).connectedDevice,
            '${controller.connectedDevice!.name}\n${controller.connectedDevice!.address}',
            Icons.bluetooth_connected,
            AppColors.success,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () async {
              try {
                await controller.disconnect();
              } catch (e) {
                if (mounted) {
                  print('disconnectError: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Disconnect error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: Text(S.of(context).disconnect),
          ),
        ],
      ],
    );
  }

  Widget _buildSunmiPrinterContent(SunmiPrinterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Paper Width Settings
        _buildPaperWidthSelector(),
        SizedBox(height: 16.h),

        _buildStatusCard(
          S.of(context).printerTypeSunmi,
          controller.isInitialized
              ? S.of(context).ready
              : S.of(context).notInitialized,
          controller.isInitialized ? Icons.check_circle : Icons.warning,
          controller.isInitialized ? AppColors.success : AppColors.warning,
        ),
        SizedBox(height: 16.h),

        // Initialize Button
        ElevatedButton.icon(
          onPressed: () async {
            try {
              await controller.initPrinter();
              if (!mounted) return;

              final String message;
              final Color bgColor;
              if (controller.isInitialized) {
                message = S.of(context).printerInitialized;
                bgColor = AppColors.success;
              } else {
                message =
                    'Printer not available. This device may not have a Sunmi printer.';
                bgColor = AppColors.warning;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: bgColor),
              );
              setState(() {});
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Init error: $e'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          icon: const Icon(Icons.power_settings_new),
          label: Text(S.of(context).initializePrinter),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryX(context),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
          ),
        ),
        SizedBox(height: 16.h),

        // Test Print Button
        ElevatedButton.icon(
          onPressed: controller.isInitialized
              ? () async {
                  try {
                    await controller.printText(
                      'Test Print',
                      bold: true,
                      align: SunmiPrintAlign.CENTER,
                    );
                    await controller.lineWrap(2);
                    await controller.printText('Hello from Sunmi Printer!');
                    await controller.lineWrap(3);
                    await controller.cutPaper();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.of(context).printSent)),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      print('printError: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Print error: $e')),
                      );
                    }
                  }
                }
              : null,
          icon: const Icon(Icons.print),
          label: Text(S.of(context).testPrint),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryX(context),
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(
    String title,
    String status,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: AppColors.surface(context),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(
    PrinterDevice device,
    BluetoothPrinterController controller,
  ) {
    // Check both connectedDevice and isConnected for accurate status
    final isDeviceConnected =
        controller.connectedDevice?.address == device.address;
    final isControllerConnected = controller.isConnected;
    final isConnected = isDeviceConnected && isControllerConnected;

    return Card(
      color: AppColors.surface(context),
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Icon(
          isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
          color: isConnected
              ? AppColors.success
              : AppColors.textSecondary(context),
        ),
        title: Text(
          device.name.isNotEmpty ? device.name : S.of(context).unknown,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          device.address ?? '',
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 12.sp,
          ),
        ),
        trailing: isConnected
            ? Icon(Icons.check_circle, color: AppColors.success)
            : ElevatedButton(
                onPressed: () async {
                  try {
                    final connected = await controller.connect(device);
                    if (mounted) {
                      setState(() {}); // Refresh UI after connection attempt
                      // Handle null case - treat as false
                      final isConnected = connected == true;
                      if (isConnected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              S.of(context).connectedToDevice(device.name),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).connectionFailed),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() {}); // Refresh UI even on error
                      debugPrint('connectionError: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Connection error: ${e.toString()}'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryX(context),
                  foregroundColor: Colors.white,
                ),
                child: Text(S.of(context).connect),
              ),
      ),
    );
  }

  Widget _buildPaperWidthSelector() {
    if (_isLoadingPaperWidth) {
      return Card(
        color: AppColors.surface(context),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      color: AppColors.surface(context),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).paperWidth,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            SizedBox(height: 16.h),
            // Radio buttons for paper width selection
            RadioListTile<String>(
              title: Text('58mm (${PaperPreset.mm58.width}px)'),
              value: PaperPreset.mm58.toString(),
              groupValue: _selectedPaperWidth,
              onChanged: (value) => _updatePaperWidth(value),
              activeColor: AppColors.primaryX(context),
            ),
            RadioListTile<String>(
              title: Text('80mm (${PaperPreset.mm80.width}px)'),
              value: PaperPreset.mm80.toString(),
              groupValue: _selectedPaperWidth,
              onChanged: (value) => _updatePaperWidth(value),
              activeColor: AppColors.primaryX(context),
            ),
            RadioListTile<String>(
              title: Text('110mm (${PaperPreset.mm110.width}px)'),
              value: PaperPreset.mm110.toString(),
              groupValue: _selectedPaperWidth,
              onChanged: (value) => _updatePaperWidth(value),
              activeColor: AppColors.primaryX(context),
            ),
            RadioListTile<String>(
              title: Text('Auto (Use full printer width)'),
              subtitle: Text(
                'Automatically uses maximum width (110mm) or detects from printer name',
              ),
              value: 'auto',
              groupValue: _selectedPaperWidth,
              onChanged: (value) => _updatePaperWidth(value),
              activeColor: AppColors.primaryX(context),
            ),
          ],
        ),
      ),
    );
  }
}
