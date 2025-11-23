import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

class PrinterDiscoveryWidget extends StatelessWidget {
  final Stream<List<PrinterDevice>> scanResults$;
  final bool isScanning;
  final PrinterDevice? connectedDevice;
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onStartScan;
  final VoidCallback onStopScan;
  final ValueChanged<PrinterDevice> onConnectToDevice;

  const PrinterDiscoveryWidget({
    super.key,
    required this.scanResults$,
    required this.isScanning,
    this.connectedDevice,
    required this.isConnected,
    this.isConnecting = false,
    required this.onStartScan,
    required this.onStopScan,
    required this.onConnectToDevice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).printers,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              if (isScanning)
                TextButton.icon(
                  onPressed: onStopScan,
                  icon: const Icon(Icons.stop),
                  label: Text(S.of(context).stop),
                )
              else
                TextButton.icon(
                  onPressed: onStartScan,
                  icon: const Icon(Icons.search),
                  label: Text(S.of(context).search),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          StreamBuilder<List<PrinterDevice>>(
            stream: scanResults$,
            initialData: const [],
            builder: (context, snapshot) {
              final allDevices = snapshot.data ?? [];

              // تصفية الطابعة المتصلة من القائمة
              final devices = allDevices.toList();

              if (devices.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Text(
                      isScanning
                          ? S.of(context).searchingForPrinters
                          : isConnected
                          ? S.of(context).connectedPrinterShownAtTop
                          : S.of(context).noPrintersPressSearch,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: devices.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return ListTile(
                    leading: Icon(Icons.bluetooth, color: AppColors.primary),
                    title: Text(
                      device.name.isEmpty ? S.of(context).unknown : device.name,
                    ),
                    subtitle: Text(device.address ?? ''),
                    trailing: ElevatedButton(
                      onPressed: isConnecting
                          ? null
                          : () => onConnectToDevice(device),
                      child: isConnecting
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(S.of(context).connect),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
