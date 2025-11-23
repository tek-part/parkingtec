import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:parkingtec/core/errors/failure.dart';

/// Maps exceptions to Failures
/// Converts various exception types to domain-specific failures
class ExceptionMapper {
  /// Convert Exception to Failure
  static Failure toFailure(dynamic exception) {
    if (exception is DioException) {
      return _mapDioException(exception);
    } else if (exception is FormatException) {
      // إظهار تفاصيل أكثر عن الخطأ
      debugPrint('=== FormatException Details ===');
      debugPrint('Message: ${exception.message}');
      debugPrint('Source: ${exception.source}');
      debugPrint('Offset: ${exception.offset}');
      debugPrint('==============================');
      return ValidationFailure(
        'Invalid data format: ${exception.message}',
      );
    } else if (exception is Exception) {
      debugPrint('Exception: ${exception.toString()}');
      debugPrint('Type: ${exception.runtimeType}');
      return ServerFailure(exception.toString());
    } else {
      debugPrint('Unknown error: ${exception.toString()}');
      debugPrint('Type: ${exception.runtimeType}');
      return ServerFailure(exception.toString());
    }
  }

  /// Map DioException to appropriate Failure
  static Failure _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode ?? 0;
        final responseData = exception.response?.data;
        debugPrint('=== DioException badResponse ===');
        debugPrint('Status Code: $statusCode');
        debugPrint('Response Data: $responseData');
        debugPrint('Response Type: ${responseData.runtimeType}');
        debugPrint('===============================');
        
        // Extract error message from response.data
        String? errorMessage;
        if (responseData != null) {
          if (responseData is Map<String, dynamic>) {
            // Try to get message from response.data['message']
            errorMessage = responseData['message']?.toString();
          } else if (responseData is String) {
            // If response.data is a string, use it directly
            errorMessage = responseData;
          }
        }
        
        // Fallback to statusMessage if message not found in response.data
        errorMessage ??= exception.response?.statusMessage;
        
        if (statusCode >= 500) {
          return ServerFailure(errorMessage ?? 'Server error');
        } else if (statusCode == 401 || statusCode == 403) {
          return ValidationFailure(errorMessage ?? 'Authentication failed');
        } else {
          return ValidationFailure(errorMessage ?? 'Invalid request');
        }
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');
      case DioExceptionType.unknown:
      default:
        if (exception.error is SocketException) {
          return const NetworkFailure('No internet connection');
        }
        return NetworkFailure(exception.message ?? 'Network error');
    }
  }

  /// Map HTTP status code to Failure
  static Failure mapStatusCode(int statusCode, String? message) {
    if (statusCode >= 500) {
      return ServerFailure(message ?? 'Server error');
    } else if (statusCode == 401 || statusCode == 403) {
      return const ValidationFailure('Authentication failed');
    } else if (statusCode >= 400) {
      return ValidationFailure(message ?? 'Invalid request');
    } else {
      return ServerFailure(message ?? 'Unknown error');
    }
  }
}

