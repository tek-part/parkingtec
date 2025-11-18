import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';

/// Extension on Either for convenient error handling
extension EitherX<L extends Failure, R> on Either<L, R> {
  /// Get the Right value, throws if Left
  R getRight() => fold((l) => throw Exception(l.message), (r) => r);

  /// Get the Left value, throws if Right
  L getLeft() =>
      fold((l) => l, (r) => throw Exception('Expected Left, got Right'));

  /// Map both sides of Either
  T foldMap<T>({
    required T Function(L) failure,
    required T Function(R) success,
  }) => fold(failure, success);

  /// FlatMap operation for chaining Either operations
  Either<L, T> flatMap<T>(Either<L, T> Function(R r) f) =>
      fold((l) => Left(l), f);
}
