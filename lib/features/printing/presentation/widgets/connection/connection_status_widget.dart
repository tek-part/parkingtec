import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;
  final BluetoothDevice? connectedDevice;
  final VoidCallback? onDisconnect;

  const ConnectionStatusWidget({
    super.key,
    required this.isConnected,
    this.connectedDevice,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border(context),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: isConnected ? AppColors.success : AppColors.error,
            size: 32.sp,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected
                      ? S.of(context).connected
                      : S.of(context).disconnected,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isConnected
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
                if (connectedDevice != null)
                  Text(
                    connectedDevice!.name.isEmpty
                        ? connectedDevice!.address
                        : connectedDevice!.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
              ],
            ),
          ),
          if (isConnected && onDisconnect != null)
            TextButton.icon(
              onPressed: onDisconnect,
              icon: const Icon(Icons.close),
              label: Text(S.of(context).disconnect),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
        ],
      ),
    );
  }
}

