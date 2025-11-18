import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';

class LogoutConfirmationDialog extends ConsumerWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.logout, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Text(
            S.of(context).logout,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        S.of(context).areYouSureYouWantToLogout,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.textSecondary(context),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: AppColors.textSecondary(context)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _handleLogout(context, ref);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(S.of(context).logout),
        ),
      ],
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    // TODO: Implement logout logic
    context.go(Routes.login);
  }
}
