import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_logo_widget.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_title_widget.dart';

/// Main Content Widget for Login Page
class LoginContentWidget extends StatelessWidget {
  final AnimationController animationController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLogin;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? passwordValidator;

  const LoginContentWidget({
    super.key,
    required this.animationController,
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onLogin,
    this.phoneValidator,
    this.passwordValidator,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40.h),

          // Logo Section
          LoginLogoWidget(animationController: animationController),

          SizedBox(height: 40.h),

          // Title Section
          const LoginTitleWidget(),

          SizedBox(height: 48.h),

          // Form Fields
          LoginFormWidget(
            phoneController: phoneController,
            passwordController: passwordController,
            obscurePassword: obscurePassword,
            isLoading: isLoading,
            onTogglePasswordVisibility: onTogglePasswordVisibility,
            onLogin: onLogin,
            phoneValidator: phoneValidator,
            passwordValidator: passwordValidator,
          ),
        ],
      ),
    );
  }
}
