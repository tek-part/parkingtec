import 'dart:io';

import 'package:dio/dio.dart';
import 'package:parkingtec/core/errors/failure.dart';

/// Maps exceptions to Failures
/// Converts various exception types to domain-specific failures
class ExceptionMapper {
  /// Convert Exception to Failure
  static Failure toFailure(dynamic exception) {
    if (exception is DioException) {
      return _mapDioException(exception);
    } else if (exception is FormatException) {
      return const ValidationFailure('Invalid data format');
    } else if (exception is Exception) {
      return ServerFailure(exception.toString());
    } else {
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
        if (statusCode >= 500) {
          return ServerFailure(
            exception.response?.statusMessage ?? 'Server error',
          );
        } else if (statusCode == 401 || statusCode == 403) {
          return const ValidationFailure('Authentication failed');
        } else {
          return ValidationFailure(
            exception.response?.statusMessage ?? 'Invalid request',
          );
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

