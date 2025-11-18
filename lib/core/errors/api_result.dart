import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkingtec/core/errors/failure.dart';

part 'api_result.freezed.dart';

/// API Result using Freezed union types
/// Simple result type with success and failure states
/// Replaces ApiResponse for cleaner error handling
@freezed
class ApiResult<T> with _$ApiResult<T> {
  /// Success state with data
  const factory ApiResult.success(T data) = _Success<T>;

  /// Failure state with error
  const factory ApiResult.failure(Failure failure) = _Failure<T>;
}

/// Extension methods for ApiResult
extension ApiResultExtension<T> on ApiResult<T> {
  /// Convert ApiResult to Either<Failure, T>
  /// Useful for repositories that need Either type
  Either<Failure, T> toEither() {
    return when(
      success: (data) => Right(data),
      failure: (failure) => Left(failure),
    );
  }

  /// Check if result is success
  bool get isSuccess => this is _Success<T>;

  /// Check if result is failure
  bool get isFailure => this is _Failure<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull => when(
        success: (data) => data,
        failure: (_) => null,
      );

  /// Get failure if failure, null otherwise
  Failure? get failureOrNull => when(
        success: (_) => null,
        failure: (failure) => failure,
      );
}

