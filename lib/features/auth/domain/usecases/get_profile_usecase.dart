import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/auth/data/models/user.dart';
import 'package:parkingtec/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting user profile
/// Handles the business logic for profile retrieval
class GetProfileUseCase {
  final AuthRepository _authRepository;

  GetProfileUseCase(this._authRepository);

  Future<Either<Failure, User>> execute() async {
    return await _authRepository.getProfile();
  }
}
