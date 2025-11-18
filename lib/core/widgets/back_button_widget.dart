import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/theme/app_colors.dart';

/// Reusable Back Button Widget
/// Can be used in AppBar leading or anywhere in the app
/// Automatically handles navigation back
class BackButtonWidget extends StatelessWidget {
  final Color? iconColor;
  final VoidCallback? onPressed;
  final bool useDefaultBehavior;

  const BackButtonWidget({
    super.key,
    this.iconColor,
    this.onPressed,
    this.useDefaultBehavior = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: iconColor ?? AppColors.textPrimary(context),
        size: 24.w,
      ),
      onPressed: onPressed ??
          (useDefaultBehavior
              ? () {
                  if (context.canPop()) {
                    context.pop();
                  }
                }
              : null),
      tooltip: 'Back',
    );
  }
}

