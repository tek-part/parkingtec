import 'package:flutter/material.dart';
import 'package:parkingtec/core/theme/app_colors.dart';

/// Background Widget for Login Page
class LoginBackgroundWidget extends StatelessWidget {
  final Widget child;

  const LoginBackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryX(context).withOpacity(0.1),
            AppColors.background(context),
            AppColors.primaryX(context).withOpacity(0.05),
          ],
        ),
      ),
      child: child,
    );
  }
}
