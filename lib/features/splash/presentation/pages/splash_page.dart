import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/app_images.dart';
import 'package:parkingtec/features/auth/providers/auth_providers.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Splash Screen with Authentication Flow
///
/// This screen handles the initial app loading and authentication check:
/// 1. Shows animated splash screen with app branding
/// 2. Checks for stored authentication token
/// 3. Validates user profile and daily shift status
/// 4. Navigates to appropriate screen based on user state:
///    - No token → Login page
///    - Authenticated + Active Daily → Home page
///    - Authenticated + No Active Daily → Start Daily page
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  // Animation controllers and animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateAfterDelay();
  }

  /// Setup splash screen animations
  /// Creates fade and scale animations for smooth entrance effect
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Fade animation for smooth appearance
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Scale animation for logo entrance
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward().then((_) {
      // Stop the animation after it completes
      _animationController.stop();
    });
  }

  /// Wait for splash animation to complete before navigation
  void _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      await _checkAuthenticationAndNavigate();
    }
  }

  /// Check authentication status and navigate to appropriate screen
  ///
  /// Navigation logic:
  /// - Authenticated + Active Daily → Home page
  /// - Authenticated + No Active Daily → Start Daily page
  /// - Not Authenticated → Login page
  /// - Error → Login page (fallback)
  Future<void> _checkAuthenticationAndNavigate() async {
    try {
      // Check authentication status and fetch user profile first
      await ref.read(authControllerProvider.notifier).checkAuthStatus();

      final authState = ref.read(authControllerProvider);

      if (!mounted) return;

      // Only load config if user is authenticated (config requires token)
      // Note: Config is already loaded in checkAuthStatus, but we ensure it's loaded here
      // in case checkAuthStatus didn't load it (for safety)
      if (authState.maybeWhen(loaded: (_, __) => true, orElse: () => false)) {
        // User is authenticated - ensure config is loaded before navigation
        // Config should already be loaded in checkAuthStatus, but we double-check here
        final configState = ref.read(configControllerProvider);
        if (configState.maybeWhen(
          loaded: (_) => false, // If not loaded yet
          orElse: () => true, // If initial/loading/error, try to load
        )) {
          await ref.read(configControllerProvider.notifier).loadConfig();
        }
      }

      if (!mounted) return;

      if (authState.maybeWhen(loaded: (_, __) => true, orElse: () => false)) {
        if (authState.maybeWhen(
          loaded: (_, hasActiveDaily) => hasActiveDaily,
          orElse: () => false,
        )) {
          // User is authenticated and has active daily - go to home
          context.go(Routes.home);
        } else {
          // User is authenticated but no active daily - go to start daily
          context.go(Routes.dailyStart);
        }
      } else {
        // User is not authenticated - go to login (config not loaded)
        context.go(Routes.login);
      }
    } catch (e) {
      if (mounted) {
        // On error, go to login as fallback
        context.go(Routes.login);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with enhanced design
                        Container(
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
                                color: AppColors.primaryX(
                                  context,
                                ).withOpacity(0.4),
                                blurRadius: 30.r,
                                spreadRadius: 8.r,
                                offset: Offset(0, 10.h),
                              ),
                              BoxShadow(
                                color: AppColors.primaryX(
                                  context,
                                ).withOpacity(0.2),
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
                                        AppImages.logo,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Animated rings
                              ...List.generate(3, (index) {
                                return Positioned.fill(
                                  child: AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      final progress =
                                          _animationController.value;
                                      final delay = index * 0.2;
                                      final animatedProgress =
                                          (progress - delay).clamp(0.0, 1.0);

                                      // Only show rings during animation, hide them after completion
                                      if (progress >= 0.8) {
                                        return const SizedBox.shrink();
                                      }

                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.primaryX(context)
                                                .withOpacity(
                                                  (1 - animatedProgress) * 0.3,
                                                ),
                                            width: 2.w,
                                          ),
                                        ),
                                        transform: Matrix4.identity()
                                          ..scale(1 + animatedProgress * 0.5),
                                      );
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // App Title with enhanced styling
                        Text(
                          S.of(context).appTitle,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
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

                        SizedBox(height: 12.h),

                        // App Subtitle with enhanced styling
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryX(context).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.primaryX(
                                context,
                              ).withOpacity(0.2),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            S.of(context).appSubtitle,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.textSecondary(context),
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: 60.h),

                        // Enhanced loading indicator with auth status
                        Consumer(
                          builder: (context, ref, child) {
                            final authState = ref.watch(authControllerProvider);

                            return Column(
                              children: [
                                SizedBox(
                                  width: 30.w,
                                  height: 30.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.w,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryX(context),
                                    ),
                                  ),
                                ),
                                if (authState.maybeWhen(
                                  loading: () => true,
                                  orElse: () => false,
                                )) ...[
                                  SizedBox(height: 16.h),
                                  Text(
                                    S.of(context).checkingAuthentication,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary(
                                            context,
                                          ),
                                        ),
                                  ),
                                ],
                                if (authState.maybeWhen(
                                  error: (failure) => true,
                                  orElse: () => false,
                                )) ...[
                                  SizedBox(height: 16.h),
                                  Text(
                                    S.of(context).connectionErrorRetrying,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.error),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
