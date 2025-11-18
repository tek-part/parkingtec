import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase Cloud Messaging Service
/// Handles FCM token management for device notifications
class FcmService {
  static FirebaseMessaging? _firebaseMessaging;
  static String? _fcmToken;

  /// Initialize FCM service
  static Future<void> initialize() async {
    _firebaseMessaging = FirebaseMessaging.instance;

    // Request notification permissions (iOS)
    await requestPermissions();

    // Get FCM token
    await _getFcmToken();

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
    if (_firebaseMessaging == null) {
      _firebaseMessaging = FirebaseMessaging.instance;
    }

    return await _getFcmToken();
  }

  /// Get FCM token from Firebase
  static Future<String?> _getFcmToken() async {
    try {
      if (_firebaseMessaging == null) {
        _firebaseMessaging = FirebaseMessaging.instance;
      }
      _fcmToken = await _firebaseMessaging?.getToken();
      print('FCM Token obtained: $_fcmToken');
      return _fcmToken;
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
      if (_firebaseMessaging == null) {
        _firebaseMessaging = FirebaseMessaging.instance;
      }
      _fcmToken = await _firebaseMessaging?.getToken();
      print('FCM Token refreshed: $_fcmToken');
      return _fcmToken;
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
