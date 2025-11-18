import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_button.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_password_field.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_phone_field.dart';

/// Form Fields Container Widget for Login Page
class LoginFormWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLogin;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? passwordValidator;

  const LoginFormWidget({
    super.key,
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
    return Column(
      children: [
        // Phone Field
        LoginPhoneField(controller: phoneController, validator: phoneValidator),

        SizedBox(height: 20.h),

        // Password Field
        LoginPasswordField(
          controller: passwordController,
          obscurePassword: obscurePassword,
          onToggleVisibility: onTogglePasswordVisibility,
          validator: passwordValidator,
        ),

        SizedBox(height: 32.h),

        // Login Button
        LoginButton(isLoading: isLoading, onPressed: onLogin),
      ],
    );
  }
}
