import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/config/domain/entities/app_config_entity.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/features/config/presentation/states/config_state.dart';
import 'package:parkingtec/generated/l10n.dart';

class AppConfigTab extends ConsumerWidget {
  const AppConfigTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(configControllerProvider);

    // Listen for errors
    ref.listen<ConfigState>(configControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                failure.message,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    return configState.when(
      initial: () => const SizedBox.shrink(),
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryX(context),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              S.of(context).configLoading,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
            ),
          ],
        ),
      ),
      loaded: (config) => _buildConfigContent(context, config),
      error: (failure) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              S.of(context).configError,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              failure.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () =>
                  ref.read(configControllerProvider.notifier).loadConfig(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(S.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigContent(BuildContext context, AppConfigEntity config) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Config Section
          // System Name with Logo
          if (config.systemName != null || config.hasLogo) ...[
            _buildSection(
              context,
              title: S.of(context).systemName,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (config.hasLogo) ...[
                    Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.border(context),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          config.logo!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 48.w,
                                color: AppColors.textSecondary(context),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                  if (config.systemName != null)
                    Text(
                      config.systemName!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],

          // Pricing Type
          _buildSection(
            context,
            title: S.of(context).pricingType,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    config.isFixedPricing
                        ? Icons.attach_money
                        : Icons.access_time,
                    color: AppColors.primary,
                    size: 20.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    config.isFixedPricing
                        ? S.of(context).fixedPricing
                        : S.of(context).hourlyPricing,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Default Prices
          if (config.isFixedPricing && config.defaultFixedPrice != null) ...[
            _buildSection(
              context,
              title: S.of(context).defaultFixedPrice,
              child: _buildInfoRow(
                context,
                icon: Icons.attach_money,
                value:
                    '${config.defaultFixedPrice!.toStringAsFixed(2)} ${config.currencyDisplay}',
              ),
            ),
            SizedBox(height: 16.h),
          ],

          if (config.isHourlyPricing && config.defaultHourlyRate != null) ...[
            _buildSection(
              context,
              title: S.of(context).defaultHourlyRate,
              child: _buildInfoRow(
                context,
                icon: Icons.access_time,
                value:
                    '${config.defaultHourlyRate!.toStringAsFixed(2)} ${config.currencyDisplay}',
              ),
            ),
            SizedBox(height: 16.h),
          ],

          // Currency
          if (config.currency != null || config.currencySymbol != null) ...[
            _buildSection(
              context,
              title: S.of(context).currencySymbol,
              child: _buildInfoRow(
                context,
                icon: Icons.currency_exchange,
                value: config.currencyDisplay,
              ),
            ),
            SizedBox(height: 16.h),
          ],

          // Barcode Enabled
          _buildSection(
            context,
            title: S.of(context).barcodeEnabled,
            child: _buildInfoRow(
              context,
              icon: Icons.qr_code_scanner,
              value: config.barcodeEnabled
                  ? S.of(context).enabled
                  : S.of(context).disabled,
              valueColor: config.barcodeEnabled
                  ? AppColors.success
                  : AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: 16.h),

          // Show Prices
          _buildSection(
            context,
            title: S.of(context).showPrices,
            child: _buildInfoRow(
              context,
              icon: Icons.visibility,
              value: config.showPrices
                  ? S.of(context).enabled
                  : S.of(context).disabled,
              valueColor: config.showPrices
                  ? AppColors.success
                  : AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: valueColor ?? AppColors.textPrimary(context),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

