import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/errors.dart';
import 'package:parkingtec/features/daily/data/datasources/daily_remote_datasource.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/data/models/requests/start_daily_request.dart';
import 'package:parkingtec/features/daily/data/models/requests/terminate_daily_request.dart';
import 'package:parkingtec/features/daily/domain/repositories/daily_repository.dart';

/// Implementation of DailyRepository
/// Handles daily shift business logic and data flow
/// Converts ApiResult to Either<Failure, T> for functional error handling
class DailyRepositoryImpl implements DailyRepository {
  final DailyRemoteDataSource _remoteDataSource;

  DailyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Daily>> getActiveDaily() async {
    final result = await _remoteDataSource.getActiveDaily();
    return result.toEither().fold(
      (failure) => Left(failure),
      (daily) {
        if (daily == null) {
          return const Left(CacheFailure('No active daily found'));
        }
        return Right(daily);
      },
    );
  }

  @override
  Future<Either<Failure, Daily>> startDaily(StartDailyRequest request) async {
    final result = await _remoteDataSource.startDaily(request);
    return result.toEither();
  }

  @override
  Future<Either<Failure, Daily>> terminateDaily(
    TerminateDailyRequest request,
  ) async {
    final result = await _remoteDataSource.terminateDaily(request);
    return result.toEither();
  }
}
