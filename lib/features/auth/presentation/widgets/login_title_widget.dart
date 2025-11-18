import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Title Section Widget for Login Page
/// Displays welcome message and subtitle
class LoginTitleWidget extends StatelessWidget {
  const LoginTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).welcomeBack,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          S.of(context).signInToContinue,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary(context),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
