/// API Endpoints Constants
/// Contains all API endpoint strings used throughout the application
class ApiEndpoints {
  // ==================== AUTHENTICATION ENDPOINTS ====================
  static const String login = '/login';
  static const String logout = '/logout';
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String updatePassword = '/profile/update/password';
  static const String updatePicture = '/profile/update/picture';

  // ==================== DAILY SHIFT ENDPOINTS ====================
  static const String startDaily = '/dailies/start';
  static const String terminateDaily = '/dailies/terminate';
  static const String activeDaily = '/dailies/active';

  // ==================== INVOICE ENDPOINTS ====================
  static const String invoices = '/invoices';
  static const String activeInvoices = '/invoices/active';
  static const String pendingInvoices = '/invoices/pending';
  static const String createInvoice = '/invoices/store';
  static const String completeInvoice = '/invoices/complete';
  static const String scanInvoice = '/invoices/scan';

  // ==================== APP CONFIG ENDPOINTS ====================
  static const String appConfig = '/app/config';

  // Helper methods for dynamic endpoints
  static String getInvoiceById(int id) => '/invoices/$id';
  static String scanInvoiceById(int id) => '/invoices/scan/$id';
  static String payInvoice(int id) => '/invoices/$id/pay';
  static String pickupInvoice(int id) => '/invoices/$id/pickup';
  static String publicInvoice(int id) => '/p/$id';
}
