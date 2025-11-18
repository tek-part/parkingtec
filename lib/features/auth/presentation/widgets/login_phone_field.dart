import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Phone Number Input Field Widget for Login Page
class LoginPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const LoginPhoneField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryX(context).withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: S.of(context).phoneNumber,
          labelStyle: TextStyle(
            color: AppColors.primaryX(context),
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(8.w),
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.phone,
              color: AppColors.primaryX(context),
              size: 20.sp,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: AppColors.primaryX(context).withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: AppColors.primaryX(context).withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: AppColors.primaryX(context),
              width: 2.w,
            ),
          ),
          filled: true,
          fillColor: AppColors.primaryDark.withOpacity(0.05),
        ),
        keyboardType: TextInputType.phone,
        validator: validator,
      ),
    );
  }
}
