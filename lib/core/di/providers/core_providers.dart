import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/config/app_config.dart';
import 'package:parkingtec/core/services/api_service.dart';
import 'package:parkingtec/core/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Core Services Providers

/// Dio instance provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
  );
  return dio;
});

/// API Service provider
/// Returns the singleton instance of ApiService
/// Note: ApiService must be initialized in main.dart before app starts
/// This provider assumes ApiService.getInstance() was already called
final apiServiceProvider = Provider<ApiService>((ref) {
  // ApiService.getInstance() returns the singleton instance synchronously
  // after it's been initialized in main.dart
  // We use a synchronous getter to access the instance
  return ApiService.getInstanceSync();
});

/// SharedPreferences provider
final sharedPreferencesProvider = Provider<Future<SharedPreferences>>((ref) {
  return SharedPreferences.getInstance();
});

/// Secure Storage Service provider
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// App Config provider
/// Provides AppConfig with production settings
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(appName: AppConfig.getAppName());
});
