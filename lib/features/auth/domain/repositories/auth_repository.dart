import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/auth/data/models/requests/login_request.dart';
import 'package:parkingtec/features/auth/data/models/responses/login_response.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';

/// Repository interface for authentication operations
/// Defines the contract for authentication data access
abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, Unit>> logout();
}
