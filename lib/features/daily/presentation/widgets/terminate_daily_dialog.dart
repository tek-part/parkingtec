import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/widgets/form_fields.dart';
import 'package:parkingtec/features/daily/presentation/widgets/confirm_terminate_daily_dialog.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Terminate Daily Dialog
/// Shows a dialog with form fields for ending a daily session
class TerminateDailyDialog extends ConsumerStatefulWidget {
  const TerminateDailyDialog({super.key});

  @override
  ConsumerState<TerminateDailyDialog> createState() =>
      _TerminateDailyDialogState();
}

class _TerminateDailyDialogState
    extends ConsumerState<TerminateDailyDialog> {
  final TextEditingController _endBalanceController = TextEditingController( text: '0');
  final TextEditingController _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _endBalanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final endBalanceText = _endBalanceController.text.trim();
    if (endBalanceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).endBalanceRequired,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final endBalance = double.tryParse(endBalanceText);
    if (endBalance == null || endBalance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).invalidEndBalance,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final notes = _notesController.text.trim();

    // Close current dialog
    Navigator.of(context).pop();

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => ConfirmTerminateDailyDialog(
        endBalance: endBalance,
        notes: notes.isEmpty ? null : notes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.stop_circle,
            color: AppColors.error,
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              S.of(context).endSessionDialogTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AmountField(
                controller: _endBalanceController,
                label: S.of(context).endBalance,
                icon: Icons.attach_money,
              ),
              SizedBox(height: 16.h),
              NotesField(
                controller: _notesController,
                label: S.of(context).notesOptional,
                maxLength: 200,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 16.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _handleConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            S.of(context).confirm,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

