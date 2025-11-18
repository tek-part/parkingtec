import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/app_images.dart';

/// Car Animation Widget
/// Shows animated car that moves up and disappears
class CarAnimationWidget extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  final bool shouldAnimate;

  const CarAnimationWidget({
    super.key,
    this.onAnimationComplete,
    this.shouldAnimate = false,
  });

  @override
  State<CarAnimationWidget> createState() => _CarAnimationWidgetState();
}

class _CarAnimationWidgetState extends State<CarAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _fadeController;
  late Animation<Offset> _moveAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Move animation - car moves up
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _moveAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -2.0), // Move up and out of screen
        ).animate(
          CurvedAnimation(parent: _moveController, curve: Curves.easeInOut),
        );

    // Fade animation - car disappears
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0), // Start fading after 50% of move
      ),
    );

    // Listen to animation completion
    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(CarAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldAnimate && !oldWidget.shouldAnimate) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _moveController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _moveController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_moveController, _fadeController]),
      builder: (context, child) {
        return SlideTransition(
          position: _moveAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 30.r,
                    spreadRadius: 5.r,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  AppImages.fullVerticalCar,
                  fit: BoxFit.contain,
                  color: AppColors.primary.withOpacity(0.8),
                  colorBlendMode: BlendMode.srcATop,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
