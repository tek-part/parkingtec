import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/data/models/requests/terminate_daily_request.dart';
import 'package:parkingtec/features/daily/domain/repositories/daily_repository.dart';

/// Use case for terminating daily shift
/// Handles the business logic for daily shift termination
class TerminateDailyUseCase {
  final DailyRepository _dailyRepository;

  TerminateDailyUseCase(this._dailyRepository);

  Future<Either<Failure, Daily>> execute(TerminateDailyRequest request) async {
    // Business logic validation
    if (request.endBalance < 0) {
      return const Left(ValidationFailure('End balance cannot be negative'));
    }

    return await _dailyRepository.terminateDaily(request);
  }
}

