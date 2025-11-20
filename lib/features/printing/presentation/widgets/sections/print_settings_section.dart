import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/printing/providers/printing_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Widget section لإعدادات الطباعة - بسيط
class PrintSettingsSection extends ConsumerStatefulWidget {
  const PrintSettingsSection({super.key});

  @override
  ConsumerState<PrintSettingsSection> createState() =>
      _PrintSettingsSectionState();
}

class _PrintSettingsSectionState extends ConsumerState<PrintSettingsSection> {
  bool _isTestPrinting = false;

  Future<void> _performTestPrint() async {
    if (_isTestPrinting) return;

    setState(() {
      _isTestPrinting = true;
    });

    try {
      final printerType = ref.read(printerTypeProvider);

      if (printerType == PrinterType.sunmi) {
        final sunmiController = ref.read(sunmiPrinterControllerProvider);
        if (!sunmiController.isInitialized) {
          await sunmiController.initPrinter();
        }
        await sunmiController.printText(
          'Test Print',
          bold: true,
          align: SunmiPrintAlign.CENTER,
        );
        await sunmiController.lineWrap(2);
        await sunmiController.printText('Hello from Sunmi Printer!');
        await sunmiController.lineWrap(3);
        await sunmiController.cutPaper();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).testPrintSuccess),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        // Bluetooth test print
        final bluetoothController = ref.read(
          bluetoothPrinterControllerProvider,
        );
        if (!bluetoothController.isConnected) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).pleaseConnectToPrinterFirst),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        // Simple test print for Bluetooth
        // Note: You'll need to implement ESC/POS commands here
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Bluetooth test print - implement ESC/POS commands',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test print error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTestPrinting = false;
        });
      }
    }
  }

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
          Text(
            S.of(context).printSettings,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 24.h),
          // Test Print Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isTestPrinting ? null : _performTestPrint,
              icon: _isTestPrinting
                  ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.print),
              label: Text(
                _isTestPrinting
                    ? S.of(context).printing
                    : S.of(context).testPrint,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
