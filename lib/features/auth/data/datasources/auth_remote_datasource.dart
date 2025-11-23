import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:parkingtec/core/errors/api_result.dart';
import 'package:parkingtec/core/errors/exception_mapper.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/core/services/api_service.dart';
import 'package:parkingtec/features/auth/data/models/requests/login_request.dart';
import 'package:parkingtec/features/auth/data/models/responses/login_response.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';

/// Remote data source for authentication operations
/// Handles all API calls related to authentication
abstract class AuthRemoteDataSource {
  Future<ApiResult<LoginResponse>> login(LoginRequest request);
  Future<ApiResult<User>> getProfile();
  Future<ApiResult<void>> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      debugPrint('=== LOGIN REQUEST ===');
      debugPrint('Request: ${request.toJson()}');
      debugPrint('=====================');
      
      final response = await _apiService.login(request);
      
      debugPrint('=== LOGIN SUCCESS ===');
      debugPrint('Token: ${response.token}');
      debugPrint('User: ${response.user?.toJson()}');
      debugPrint('=====================');
      
      return ApiResult.success(response);
    } on DioException catch (e) {
      debugPrint('=== DIO EXCEPTION IN LOGIN ===');
      debugPrint('Type: ${e.type}');
      debugPrint('Message: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');
      debugPrint('==============================');
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    } on FormatException catch (e, stackTrace) {
      // تسجيل تفاصيل الخطأ للمساعدة في التشخيص
      debugPrint('=== LOGIN JSON PARSING ERROR ===');
      debugPrint('FormatException message: ${e.message}');
      debugPrint('Source: ${e.source}');
      debugPrint('Offset: ${e.offset}');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('================================');
      return ApiResult.failure(
        ValidationFailure('Invalid data format: ${e.message}'),
      );
    } catch (e, stackTrace) {
      debugPrint('=== UNKNOWN ERROR IN LOGIN ===');
      debugPrint('Error: $e');
      debugPrint('Type: ${e.runtimeType}');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('==============================');
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<User>> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      // Extract user from GetProfileResponse
      if (response.user == null) {
        return ApiResult.failure(
          const ServerFailure('User data not found in profile response'),
        );
      }
      return ApiResult.success(response.user!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    try {
      await _apiService.logout();
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }
}
