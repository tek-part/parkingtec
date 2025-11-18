import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/data/models/requests/start_daily_request.dart';
import 'package:parkingtec/features/daily/data/models/requests/terminate_daily_request.dart';

/// Repository interface for daily operations
/// Defines the contract for daily shift data access
abstract class DailyRepository {
  Future<Either<Failure, Daily>> getActiveDaily();
  Future<Either<Failure, Daily>> startDaily(StartDailyRequest request);
  Future<Either<Failure, Daily>> terminateDaily(TerminateDailyRequest request);
}
