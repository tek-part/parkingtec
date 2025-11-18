/// Application configuration
/// Contains application settings
class AppConfig {
  final String appName;
  final String apiBaseUrl;

  AppConfig({required this.appName, String? apiBaseUrl})
    : apiBaseUrl = apiBaseUrl ?? getApiBaseUrl();

  /// Get app name
  static String getAppName() {
    return 'TEC Parking';
  }

  /// Get API base URL
  static String getApiBaseUrl() {
    const apiUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.example.com',
    );
    return apiUrl;
  }
}
