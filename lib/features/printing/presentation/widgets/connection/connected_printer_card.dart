import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';

class ConnectedPrinterCard extends StatelessWidget {
  final BluetoothDevice connectedDevice;
  final VoidCallback onDisconnect;

  const ConnectedPrinterCard({
    super.key,
    required this.connectedDevice,
    required this.onDisconnect,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).connectedPrinter,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Icon(
                Icons.bluetooth_connected,
                color: AppColors.success,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.print,
              color: AppColors.primary,
              size: 32.sp,
            ),
            title: Text(
              connectedDevice.name.isEmpty
                  ? S.of(context).unknown
                  : connectedDevice.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                connectedDevice.address,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
            trailing: TextButton.icon(
              onPressed: onDisconnect,
              icon: const Icon(Icons.close),
              label: Text(S.of(context).disconnect),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

