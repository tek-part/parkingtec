import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/domain/repositories/daily_repository.dart';

/// Use case for getting active daily shift
/// Handles the business logic for retrieving active daily shift
/// Returns null if no active daily exists (not an error condition)
class GetActiveDailyUseCase {
  final DailyRepository _dailyRepository;

  GetActiveDailyUseCase(this._dailyRepository);

  Future<Either<Failure, Daily?>> execute() async {
    final result = await _dailyRepository.getActiveDaily();
    // If there's no active daily, return null instead of failure
    // This is a normal condition, not an error
    return result.fold((failure) {
      // If it's a validation failure (404, etc.), it means no active daily
      // This is expected behavior, not an error
      if (failure is ValidationFailure) {
        return const Right(null);
      }
      // For other errors (network, server), return the failure
      return Left(failure);
    }, (daily) => Right(daily));
  }
}
