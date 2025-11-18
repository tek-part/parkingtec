import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/errors.dart';
import 'package:parkingtec/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:parkingtec/features/auth/data/models/requests/login_request.dart';
import 'package:parkingtec/features/auth/data/models/responses/login_response.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';
import 'package:parkingtec/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
/// Handles authentication business logic and data flow
/// Converts ApiResult to Either<Failure, T> for functional error handling
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    final result = await _remoteDataSource.login(request);
    return result.toEither();
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return result.toEither();
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    final result = await _remoteDataSource.logout();
    return result.toEither().fold(
      (failure) => Left(failure),
      (_) => const Right(unit),
    );
  }
}
