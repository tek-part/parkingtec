import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parkingtec/core/routing/routes.dart';
import 'package:parkingtec/core/theme/app_colors.dart';
import 'package:parkingtec/features/auth/presentation/states/auth_state.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_background_widget.dart';
import 'package:parkingtec/features/auth/presentation/widgets/login_content_widget.dart';
import 'package:parkingtec/features/auth/providers/auth_providers.dart';
import 'package:parkingtec/features/config/providers/config_providers.dart';
import 'package:parkingtec/generated/l10n.dart';

/// Clean and organized Login Page
/// Uses modular widgets for better maintainability
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes for navigation
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        loaded: (user, hasActiveDaily) {
          // Load app config after successful login (config requires token)
          // Use unawaited to avoid blocking - config will load in background
          ref.read(configControllerProvider.notifier).loadConfig().catchError((e) {
            // Config loading failed, but don't block navigation
            // App will continue without config (graceful degradation)
          });

          // Navigate after successful login (config will load in background)
          if (mounted) {
            if (hasActiveDaily) {
              // User is authenticated and has active daily - go to home
              context.go(Routes.home);
            } else {
              // User is authenticated but no active daily - go to start daily
              context.go(Routes.dailyStart);
            }
          }
        },
        error: (failure) {
          // Show error message
          if (mounted) {
            print("error is ${failure.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).loginFailed(failure.message),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: LoginBackgroundWidget(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: LoginContentWidget(
                      animationController: _animationController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      isLoading: _isLoading,
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onLogin: _handleLogin,
                      phoneValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterPhoneNumber;
                        }
                        return null;
                      },
                      passwordValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).pleaseEnterPassword;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Handle login form submission
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Login using auth provider
      // Navigation will be handled by ref.listen in build method
      await ref
          .read(authControllerProvider.notifier)
          .login(_phoneController.text, _passwordController.text);
    } catch (e) {
      log(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).loginFailed(e.toString()),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
