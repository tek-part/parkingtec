import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure Storage Service for managing sensitive data
/// Uses Flutter Secure Storage for encrypted storage
/// Handles authentication tokens and user data securely
class SecureStorageService {
  // Configure secure storage with platform-specific options
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // Use encrypted preferences on Android
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility
          .first_unlock_this_device, // iOS keychain accessibility
    ),
  );

  // Storage keys for different data types
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // ==================== TOKEN MANAGEMENT ====================

  /// Save authentication token securely
  /// Used after successful login
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieve stored authentication token
  /// Returns null if no token exists
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // ==================== USER DATA MANAGEMENT ====================

  /// Save user data as JSON string
  /// Used to cache user profile information
  static Future<void> saveUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  /// Retrieve stored user data
  /// Returns null if no user data exists
  static Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  // ==================== STORAGE MANAGEMENT ====================

  /// Clear all stored data
  /// Used during logout or when clearing sensitive data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if user has a valid authentication token
  /// Returns true if token exists and is not empty
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
