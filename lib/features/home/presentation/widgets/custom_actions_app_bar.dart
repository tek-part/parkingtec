import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/auth/presentation/widgets/logout_dialog.dart';
import 'package:parkingtec/features/auth/providers/auth_providers.dart';
import 'package:parkingtec/features/daily/presentation/widgets/terminate_daily_dialog.dart';
import 'package:parkingtec/generated/l10n.dart';

class CustomActionsAppBar extends ConsumerWidget {
  const CustomActionsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Invoices Button
          _ActionButton(
            icon: Icons.receipt_long,
            label: S.of(context).invoices,
            onPressed: () => context.push(Routes.invoices),
          ),

          // History Button
          _ActionButton(
            icon: Icons.history,
            label: S.of(context).history,
            onPressed: () => context.go(Routes.history),
          ),

          // Settings Button
          _ActionButton(
            icon: Icons.settings,
            label: S.of(context).settings,
            onPressed: () => context.push(Routes.config),
          ),

          // End Session Button
          _ActionButton(
            icon: Icons.stop_circle,
            label: S.of(context).terminateDaily,
            onPressed: () => _showTerminateDailyDialog(context),
          ),

          // Logout Button
          _ActionButton(
            icon: Icons.logout,
            label: S.of(context).logout,
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authControllerProvider);

    if (authState.maybeWhen(
      loaded: (_, hasActiveDaily) => hasActiveDaily,
      orElse: () => false,
    )) {
      // Show logout dialog with terminate daily option
      showDialog(context: context, builder: (context) => const LogoutDialog());
    } else {
      // Direct logout if no active daily
      ref.read(authControllerProvider.notifier).logout();
      context.go(Routes.login);
    }
  }

  void _showTerminateDailyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TerminateDailyDialog(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.background(context),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.border(context), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20.w, color: AppColors.primaryX(context)),
            SizedBox(height: 4.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary(context),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
