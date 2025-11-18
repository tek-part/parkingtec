import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/data/models/requests/start_daily_request.dart';
import 'package:parkingtec/features/daily/domain/repositories/daily_repository.dart';

/// Use case for starting daily shift
/// Handles the business logic for daily shift initiation
class StartDailyUseCase {
  final DailyRepository _dailyRepository;

  StartDailyUseCase(this._dailyRepository);

  Future<Either<Failure, Daily>> execute(StartDailyRequest request) async {
    // Business logic validation
    if (request.startBalance != null && request.startBalance! < 0) {
      return const Left(ValidationFailure('Start balance cannot be negative'));
    }

    return await _dailyRepository.startDaily(request);
  }
}
