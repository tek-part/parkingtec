import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/core/utils/app_images.dart';
import 'package:parkingtec/features/home/presentation/widgets/car_animation_widget.dart';
import 'package:parkingtec/features/home/presentation/widgets/custom_actions_app_bar.dart';
import 'package:parkingtec/features/invoice/presentation/pages/create_invoice_dialog.dart';
import 'package:parkingtec/generated/l10n.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showCarAnimation = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
                    // Enhanced App Bar
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryX(context).withOpacity(0.1),
                            AppColors.primaryX(context).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24.r),
                          bottomRight: Radius.circular(24.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryX(context).withOpacity(0.1),
                            blurRadius: 20.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50.w,
                            height: 50.w,
                            child: Image.asset(
                              AppImages.logo,
                              color: AppColors.primaryX(context),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).findParking,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary(context),
                                        letterSpacing: 0.5,
                                      ),
                                ),
                                Text(
                                  S.of(context).welcomeBack,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary(context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(8.w),
                          //   decoration: BoxDecoration(
                          //     color: AppColors.primaryX(
                          //       context,
                          //     ).withOpacity(0.1),
                          //     borderRadius: BorderRadius.circular(12.r),
                          //   ),
                          //   child: Icon(
                          //     Icons.notifications_outlined,
                          //     color: AppColors.primaryX(context),
                          //     size: 20.w,
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Custom Actions App Bar
                    const CustomActionsAppBar(),

                    SizedBox(height: 20.h),

                    // Enhanced Create Invoice Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        width: double.infinity,
                        height: 60.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 15.r,
                              offset: Offset(0, 5.h),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _showCreateInvoiceDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          icon: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: Text(
                            S.of(context).createInvoice,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Enhanced Main Content Area
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withOpacity(0.05),
                              AppColors.background(context),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              blurRadius: 20.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Background Pattern
                            Positioned.fill(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  gradient: RadialGradient(
                                    center: Alignment.center,
                                    radius: 1.0,
                                    colors: [
                                      AppColors.backgroundX(
                                        context,
                                      ).withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Image.asset(
                                  AppImages.sides,
                                  color: AppColors.backgroundX(context),
                                ),
                              ),
                            ),
                            // Car Image with enhanced styling and animation
                            Positioned.fill(
                              child: Center(
                                child: _showCarAnimation
                                    ? CarAnimationWidget(
                                        shouldAnimate: _showCarAnimation,
                                        onAnimationComplete: () {
                                          setState(() {
                                            _showCarAnimation = false;
                                          });
                                          // Navigate to start daily page
                                          context.go(Routes.dailyStart);
                                        },
                                      )
                                    : AnimatedBuilder(
                                        animation: _animationController,
                                        builder: (context, child) {
                                          return FadeTransition(
                                            opacity: _fadeAnimation,
                                            child: SlideTransition(
                                              position: _slideAnimation,
                                              child: Container(
                                                width: 300.w,
                                                height: 300.h,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                    20.r,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.primary
                                                          .withOpacity(0.2),
                                                      blurRadius: 30.r,
                                                      spreadRadius: 5.r,
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                    20.r,
                                                  ),
                                                  child: Image.asset(
                                                    AppImages.fullVerticalCar,
                                                    fit: BoxFit.contain,
                                                    colorBlendMode: BlendMode.srcATop,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            // // App Title Overlay
                            // Positioned(
                            //   bottom: 40.h,
                            //   left: 0,
                            //   right: 0,
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: 24.w,
                            //       vertical: 16.h,
                            //     ),
                            //     margin: EdgeInsets.symmetric(
                            //       horizontal: 20.w,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white.withOpacity(0.9),
                            //       borderRadius: BorderRadius.circular(16.r),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.black.withOpacity(0.1),
                            //           blurRadius: 10.r,
                            //           offset: Offset(0, 2.h),
                            //         ),
                            //       ],
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         Text(
                            //           S.of(context).appTitle,
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .headlineSmall
                            //               ?.copyWith(
                            //                 color: AppColors.textPrimary(
                            //                   context,
                            //                 ),
                            //                 fontWeight: FontWeight.w800,
                            //                 letterSpacing: 0.5,
                            //               ),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //         SizedBox(height: 4.h),
                            //         Text(
                            //           S.of(context).appSubtitle,
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .bodyMedium
                            //               ?.copyWith(
                            //                 color: AppColors.textSecondary(
                            //                   context,
                            //                 ),
                            //                 fontWeight: FontWeight.w500,
                            //               ),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // // Enhanced Terminate Daily Button
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                    //   child: Container(
                    //     width: double.infinity,
                    //     height: 56.h,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: AppColors.error.withOpacity(0.3),
                    //         width: 2.w,
                    //       ),
                    //       borderRadius: BorderRadius.circular(16.r),
                    //       color: AppColors.error.withOpacity(0.05),
                    //     ),
                    //     child: OutlinedButton.icon(
                    //       onPressed: () =>
                    //           _showConfirmationDialogForTerminateDaily(
                    //             context,
                    //           ),
                    //       style: OutlinedButton.styleFrom(
                    //         side: BorderSide.none,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(16.r),
                    //         ),
                    //       ),
                    //       icon: Icon(
                    //         Icons.stop_circle_outlined,
                    //         color: AppColors.error,
                    //         size: 20.w,
                    //       ),
                    //       label: Text(
                    //         S.of(context).terminateDaily,
                    //         style: TextStyle(
                    //           color: AppColors.error,
                    //           fontSize: 16.sp,
                    //           fontWeight: FontWeight.w600,
                    //           letterSpacing: 0.5,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
          ],
        ),
      ),
    );
  }

  void _showCreateInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateInvoiceDialog(),
    );
  }
}
