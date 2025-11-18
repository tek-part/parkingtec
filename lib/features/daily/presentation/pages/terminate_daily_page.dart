import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/app_images.dart';
import 'package:parkingtec/core/widgets/form_fields.dart';
import 'package:parkingtec/features/auth/presentation/widgets/logout_dialog.dart';
import 'package:parkingtec/features/daily/presentation/states/daily_state.dart';
import 'package:parkingtec/features/daily/providers/daily_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

class TerminateDailyPage extends ConsumerStatefulWidget {
  const TerminateDailyPage({super.key});

  @override
  ConsumerState<TerminateDailyPage> createState() => _TerminateDailyPageState();
}

class _TerminateDailyPageState extends ConsumerState<TerminateDailyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _carAnimationController;
  late Animation<Offset> _carSlideAnimation;

  final TextEditingController _endBalanceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupCarAnimation();
    // Start animation after a small delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _carAnimationController.forward();
      }
    });
  }

  void _setupCarAnimation() {
    _carAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _carSlideAnimation =
        Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // Start from outside left
          end: const Offset(-0.3, 0.0), // Stop at the start of left screen
        ).animate(
          CurvedAnimation(
            parent: _carAnimationController,
            curve: Curves.easeOut,
          ),
        );
  }

  /// Reverse car animation (move back to the left)
  Future<void> _reverseCarAnimation() async {
    await _carAnimationController.reverse();
  }

  /// Terminate daily session
  Future<void> _terminateDaily() async {
    // Validate end balance
    final endBalanceText = _endBalanceController.text.trim();
    if (endBalanceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).endBalanceRequired,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final endBalance = double.tryParse(endBalanceText);
    if (endBalance == null || endBalance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).invalidEndBalance,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final notes = _notesController.text.trim();

    // Call controller to terminate daily
    await ref
        .read(dailyControllerProvider.notifier)
        .terminateDaily(endBalance, notes.isEmpty ? null : notes);
  }

  @override
  void dispose() {
    _carAnimationController.dispose();
    _endBalanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(context: context, builder: (context) => const LogoutDialog());
  }

  @override
  Widget build(BuildContext context) {
    final dailyState = ref.watch(dailyControllerProvider);
    final isLoading = dailyState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    // Listen to state changes for navigation and error handling
    ref.listen<DailyState>(dailyControllerProvider, (previous, next) {
      next.maybeWhen(
        loaded: (daily, _) {
          // Success: reverse animation then navigate to start daily page
          if (daily == null) {
            _reverseCarAnimation().then((_) {
              if (mounted) {
                context.go(Routes.dailyStart);
              }
            });
          }
        },
        error: (failure) {
          // Show error message
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

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced App Bar (like home_page.dart)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 20.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryX(context),
                        size: 20.w,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          S.of(context).terminateDaily,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary(context),
                                letterSpacing: 0.5,
                              ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: AppColors.error,
                          size: 20.w,
                        ),
                        onPressed: _showLogoutDialog,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 300.h,
                child: Stack(
                  alignment: AlignmentGeometry.center,
                  fit: StackFit.expand,
                  children: [
                    Transform.rotate(
                      angle: 3.14159 / 2,
                      child: SizedBox(
                        height: 100.h,
                        width: 1.sw,
                        child: Image.asset(
                          AppImages.sides,
                          height: 300.h,
                          width: 1.sw,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.h),
                      child: Center(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: SlideTransition(
                            position: _carSlideAnimation,
                            child: Image.asset(
                              AppImages.sideCar,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Form Section
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // End Balance Field
                    AmountField(
                      controller: _endBalanceController,
                      label: S.of(context).endBalance,
                      icon: Icons.attach_money,
                    ),
                    SizedBox(height: 16.h),
                    // Notes Field
                    NotesField(
                      controller: _notesController,
                      label: S.of(context).notesOptional,
                      maxLength: 200,
                    ),
                    SizedBox(height: 24.h),
                    // End Session Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _terminateDaily,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        disabledBackgroundColor: AppColors.error.withOpacity(
                          0.5,
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              S.of(context).endSession,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
