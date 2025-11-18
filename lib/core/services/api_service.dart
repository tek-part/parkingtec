import 'package:dio/dio.dart';
import 'package:parkingtec/core/constants/api_endpoints.dart';
import 'package:parkingtec/core/services/secure_storage_service.dart';
import 'package:parkingtec/features/auth/data/models/requests/login_request.dart';
import 'package:parkingtec/features/auth/data/models/requests/update_profile_request.dart';
import 'package:parkingtec/features/auth/data/models/responses/get_profile_response.dart';
import 'package:parkingtec/features/auth/data/models/responses/login_response.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/data/models/requests/start_daily_request.dart';
import 'package:parkingtec/features/daily/data/models/requests/terminate_daily_request.dart';
import 'package:parkingtec/features/config/data/models/responses/get_app_config_response.dart';
import 'package:parkingtec/features/invoice/data/models/invoice.dart';
import 'package:parkingtec/features/invoice/data/models/requests/complete_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/create_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/requests/pay_invoice_request.dart';
import 'package:parkingtec/features/invoice/data/models/responses/get_invoice_response.dart';
import 'package:parkingtec/features/invoice/data/models/responses/get_invoices_list_response.dart';
import 'package:parkingtec/features/invoice/data/models/responses/pay_invoice_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

/// API Service using Retrofit and Dio for HTTP requests
/// Handles all API endpoints for the parking management system
@RestApi(baseUrl: "https://parking.alwafierp.com/api")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService? _instance;
  static Dio? _dio;

  /// Get singleton instance of ApiService
  /// Initializes Dio with interceptors and configuration
  static Future<ApiService> getInstance() async {
    if (_instance == null) {
      _dio = Dio();
      _setupDio();
      _instance = ApiService(_dio!);
    }
    return _instance!;
  }

  /// Get singleton instance synchronously
  /// Throws StateError if ApiService hasn't been initialized yet
  /// Use this after calling getInstance() in main.dart
  static ApiService getInstanceSync() {
    if (_instance == null) {
      throw StateError(
        'ApiService has not been initialized. Call ApiService.getInstance() in main.dart first.',
      );
    }
    return _instance!;
  }

  /// Setup Dio configuration with interceptors
  /// - Authentication interceptor for token management
  /// - Logging interceptor for debugging
  /// - Error handling for 401 responses
  static void _setupDio() {
    _dio!.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add authentication interceptor
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add Bearer token to all requests
          final token = await SecureStorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized responses
          if (error.response?.statusCode == 401) {
            // Token expired, clear storage and redirect to login
            await SecureStorageService.clearAll();
          }
          handler.next(error);
        },
      ),
    );

    // Add pretty logging interceptor for debugging
    _dio!.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  // ==================== AUTHENTICATION ENDPOINTS ====================

  /// Login user with phone and password
  /// Returns user data and authentication token

  @POST(ApiEndpoints.login)
  Future<LoginResponse> login(@Body() LoginRequest loginData);

  /// Get current user profile information
  /// Requires authentication token
  /// Response structure: { "data": { ... user data ... }, "message": "..." }
  @GET(ApiEndpoints.profile)
  Future<GetProfileResponse> getProfile();

  /// Check if user has an active daily shift
  /// Returns daily information if active, null otherwise
  @GET(ApiEndpoints.activeDaily)
  Future<Daily?> getActiveDaily();

  /// Logout user and invalidate token
  @POST(ApiEndpoints.logout)
  Future<void> logout();

  // ==================== INVOICE ENDPOINTS ====================

  /// Get all invoices for the current user
  /// Optional query parameter: car_num for search
  @GET(ApiEndpoints.invoices)
  Future<GetInvoicesListResponse> getInvoices({
    @Query('car_num') String? carNum,
  });

  /// Get only active invoices
  @GET(ApiEndpoints.activeInvoices)
  Future<GetInvoicesListResponse> getActiveInvoices();

  /// Get pending invoices (waiting for car retrieval)
  @GET(ApiEndpoints.pendingInvoices)
  Future<GetInvoicesListResponse> getPendingInvoices();

  /// Get specific invoice by ID
  @GET('/invoices/{id}')
  Future<GetInvoiceResponse> getInvoice(@Path('id') int invoiceId);

  /// Create new parking invoice
  @POST(ApiEndpoints.createInvoice)
  Future<GetInvoiceResponse> createInvoice(
    @Body() CreateInvoiceRequest invoiceData,
  );

  /// Complete parking invoice with final amount
  @POST(ApiEndpoints.completeInvoice)
  Future<GetInvoiceResponse> completeInvoice(
    @Body() CompleteInvoiceRequest completeData,
  );

  /// Pay invoice (for fixed pricing)
  @POST('/invoices/{id}/pay')
  Future<PayInvoiceResponse> payInvoice(
    @Path('id') int invoiceId,
    @Body() PayInvoiceRequest request,
  );

  /// Pickup invoice (for hourly pricing)
  @POST('/invoices/{id}/pickup')
  Future<GetInvoiceResponse> pickupInvoice(@Path('id') int invoiceId);

  /// Scan QR code for invoice (public endpoint)
  @GET('/p/{id}')
  Future<GetInvoiceResponse> scanInvoice(
    @Path('id') int invoiceId,
    @Query('json') int? json,
  );

  // ==================== DAILY SHIFT ENDPOINTS ====================

  /// Start new daily shift
  @POST(ApiEndpoints.startDaily)
  Future<Daily> startDaily(@Body() StartDailyRequest dailyData);

  /// Terminate current daily shift
  @POST(ApiEndpoints.terminateDaily)
  Future<Daily> terminateDaily(@Body() TerminateDailyRequest dailyData);

  // ==================== PROFILE ENDPOINTS ====================

  /// Update user profile information
  @POST(ApiEndpoints.updateProfile)
  Future<User> updateProfile(@Body() UpdateProfileRequest profileData);

  // ==================== APP CONFIG ENDPOINTS ====================

  /// Get application configuration
  /// Requires authentication token
  /// Response structure: { "data": { ... config data ... }, "message": "..." }
  @GET(ApiEndpoints.appConfig)
  Future<GetAppConfigResponse> getAppConfig();

  // /// Update user password
  // @POST(ApiEndpoints.updatePassword)
  // Future<ApiResponse<Map<String, dynamic>>> updatePassword(
  //   @Body() UpdatePasswordRequest passwordData,
  // );

  // /// Update user profile picture
  // @POST(ApiEndpoints.updatePicture)
  // @MultiPart()
  // Future<ApiResponse<Map<String, dynamic>>> updatePicture(@Part() File picture);
}
