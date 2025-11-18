import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user logout
/// Handles the business logic for user logout
class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<Either<Failure, Unit>> execute() async {
    return await _authRepository.logout();
  }
}
