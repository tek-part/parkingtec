/// Application Routes
/// Centralized route definitions for the entire app
/// All route paths should be defined here to avoid hardcoded strings
class Routes {
  Routes._(); // Private constructor to prevent instantiation

  // ==================== Static Route Constants ====================

  /// Splash screen route
  static const String splash = '/splash';

  /// Login page route
  static const String login = '/login';

  /// Home page route (root)
  static const String home = '/';

  /// Vehicle entry page route (base)
  static const String vehicle = '/vehicle';

  /// History page route
  static const String history = '/history';

  /// Daily start page route
  static const String dailyStart = '/daily/start';

  /// Daily terminate page route
  static const String dailyTerminate = '/daily/terminate';

  /// Config page route
  static const String config = '/config';

  /// Settings page route (with tabs)
  static const String settings = '/settings';

  /// Invoices list page route
  static const String invoices = '/invoices';

  /// Printer settings page route
  static const String printerSettings = '/printer-settings';

  // ==================== Route Helper Methods ====================
  // These methods generate routes with parameters

  /// Lot details page route with lot ID
  /// Example: Routes.lotDetails('123') => '/lot/123'
  static String lotDetails(String id) => '/lot/$id';

  /// Session created page route with session ID
  /// Example: Routes.sessionCreated('123') => '/session/created/123'
  static String sessionCreated(String id) => '/session/created/$id';

  /// Active session page route with session ID
  /// Example: Routes.sessionActive('123') => '/session/active/123'
  static String sessionActive(String id) => '/session/active/$id';

  /// End session page route with session ID
  /// Example: Routes.sessionEnd('123') => '/session/end/123'
  static String sessionEnd(String id) => '/session/end/$id';

  /// Receipt page route with receipt ID
  /// Example: Routes.receipt('123') => '/receipt/123'
  static String receipt(String id) => '/receipt/$id';

  /// Invoice details page route with invoice ID
  /// Example: Routes.invoiceDetails(123) => '/invoices/123'
  static String invoiceDetails(int id) => '/invoices/$id';

  /// Vehicle entry page route with optional lot ID query parameter
  /// Example: Routes.vehicleEntry(lotId: '123') => '/vehicle?lotId=123'
  /// Example: Routes.vehicleEntry() => '/vehicle'
  static String vehicleEntry({String? lotId}) {
    if (lotId != null && lotId.isNotEmpty) {
      return '/vehicle?lotId=$lotId';
    }
    return vehicle;
  }
}
