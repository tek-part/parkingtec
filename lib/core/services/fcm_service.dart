import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase Cloud Messaging Service
/// Handles FCM token management for device notifications
class FcmService {
  static FirebaseMessaging? _firebaseMessaging;
  static String? _fcmToken;

  /// Initialize FCM service
  static Future<void> initialize() async {
    try {
      _firebaseMessaging = FirebaseMessaging.instance;

      // Request notification permissions (iOS)
      await requestPermissions();

      // Get FCM token (non-blocking, won't crash app if it fails)
      _getFcmToken().catchError((e) {
        print('FCM initialization error (non-critical): $e');
        // Don't throw - FCM is optional for app functionality
        return null;
      });

      // Listen for token refresh
      _firebaseMessaging?.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('FCM Token refreshed: $newToken');
        // TODO: Send new token to your backend
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        // TODO: Show local notification or update UI
      });

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Notification opened app: ${message.messageId}');
        print('Message data: ${message.data}');
        // TODO: Navigate to specific screen based on message data
      });

      // Check if app was opened from a notification (when app was terminated)
      final initialMessage = await _firebaseMessaging?.getInitialMessage();
      if (initialMessage != null) {
        print('App opened from notification: ${initialMessage.messageId}');
        print('Message data: ${initialMessage.data}');
        // TODO: Navigate to specific screen based on message data
      }
    } catch (e) {
      print('FCM initialization error (non-critical): $e');
      // Don't throw - FCM is optional for app functionality
      // App can still work without FCM token
    }
  }

  /// Set background message handler
  /// Must be called before runApp()
  static void setBackgroundMessageHandler(
    Future<void> Function(RemoteMessage message) handler,
  ) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  /// Get FCM token for device
  static Future<String?> getFcmToken() async {
    // If token already cached, return it
    if (_fcmToken != null) return _fcmToken;

    // If FirebaseMessaging not initialized, initialize it first
    _firebaseMessaging ??= FirebaseMessaging.instance;

    return await _getFcmToken();
  }

  /// Get FCM token from Firebase
  static Future<String?> _getFcmToken() async {
    try {
      _firebaseMessaging ??= FirebaseMessaging.instance;
      
      // Add retry logic for SERVICE_NOT_AVAILABLE error
      int retries = 3;
      while (retries > 0) {
        try {
          _fcmToken = await _firebaseMessaging?.getToken();
          if (_fcmToken != null) {
            print('FCM Token obtained: $_fcmToken');
            return _fcmToken;
          }
        } catch (e) {
          final errorMessage = e.toString();
          
          // Check if it's a SERVICE_NOT_AVAILABLE error
          if (errorMessage.contains('SERVICE_NOT_AVAILABLE')) {
            retries--;
            if (retries > 0) {
              print('FCM SERVICE_NOT_AVAILABLE, retrying in 2 seconds... ($retries attempts left)');
              await Future.delayed(const Duration(seconds: 2));
              continue;
            } else {
              print('FCM SERVICE_NOT_AVAILABLE: Google Play Services may not be available. '
                  'This is normal on emulators without Google Play Services.');
              return null;
            }
          } else {
            // Other errors, don't retry
            print('Error getting FCM token: $e');
            return null;
          }
        }
        retries--;
      }
      
      return null;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  /// Request notification permissions (iOS)
  static Future<bool> requestPermissions() async {
    try {
      final settings = await _firebaseMessaging?.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );
      final isAuthorized = settings?.authorizationStatus == AuthorizationStatus.authorized ||
          settings?.authorizationStatus == AuthorizationStatus.provisional;
      print('Notification permission status: ${settings?.authorizationStatus}');
      return isAuthorized;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  /// Refresh FCM token
  static Future<String?> refreshToken() async {
    try {
      _firebaseMessaging ??= FirebaseMessaging.instance;
      
      // Use the same retry logic as _getFcmToken
      return await _getFcmToken();
    } catch (e) {
      print('Error refreshing FCM token: $e');
      return null;
    }
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging?.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging?.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  /// Delete FCM token
  static Future<void> deleteToken() async {
    try {
      await _firebaseMessaging?.deleteToken();
      _fcmToken = null;
      print('FCM Token deleted');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}
