import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';

/// Animated Logo Widget for Login Page
/// Displays the app logo with animated rings effect
class LoginLogoWidget extends StatelessWidget {
  final AnimationController animationController;

  const LoginLogoWidget({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 150.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primaryX(context),
            AppColors.primaryX(context).withOpacity(0.8),
            AppColors.primaryX(context).withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryX(context).withOpacity(0.4),
            blurRadius: 30.r,
            spreadRadius: 8.r,
            offset: Offset(0, 10.h),
          ),
          BoxShadow(
            color: AppColors.primaryX(context).withOpacity(0.2),
            blurRadius: 50.r,
            spreadRadius: 15.r,
            offset: Offset(0, 20.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circle
          Container(
            width: 150.w,
            height: 150.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          // Logo image
          Center(
            child: ClipOval(
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Image.asset(
                    'assets/icons/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Animated rings
          ...List.generate(2, (index) {
            return Positioned.fill(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  final progress = animationController.value;
                  final delay = index * 0.3;
                  final animatedProgress = (progress - delay).clamp(0.0, 1.0);

                  // Only show rings during animation, hide them after completion
                  if (progress >= 0.8) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(
                          (1 - animatedProgress) * 0.3,
                        ),
                        width: 2.w,
                      ),
                    ),
                    transform: Matrix4.identity()
                      ..scale(1 + animatedProgress * 0.3),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
