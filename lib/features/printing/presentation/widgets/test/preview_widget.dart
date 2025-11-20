import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/generated/l10n.dart';

class PreviewWidget extends StatelessWidget {
  final List<Uint8List> previewChunks;

  const PreviewWidget({
    super.key,
    required this.previewChunks,
  });

  @override
  Widget build(BuildContext context) {
    if (previewChunks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).previewLabel,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 8.h),
        ...previewChunks.map(
          (chunk) => Container(
            margin: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border(context)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.memory(chunk, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}

