import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/core/services/fcm_service.dart';
import 'package:parkingtec/features/auth/data/models/requests/login_request.dart';
import 'package:parkingtec/features/auth/data/models/responses/login_response.dart';
import 'package:parkingtec/features/auth/domain/repositories/auth_repository.dart';

/// Use case for user login
/// Handles the business logic for user authentication
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, LoginResponse>> execute(LoginRequest request) async {
    // Business logic validation
    if (request.phone.isEmpty) {
      return const Left(ValidationFailure('Phone number is required'));
    }
    if (request.password.isEmpty) {
      return const Left(ValidationFailure('Password is required'));
    }
    if (request.deviceToken == null) {
      request.deviceToken = await FcmService.getFcmToken();
      if (request.deviceToken == null) {
       request.deviceToken = '123456789012345678901234';
      }
    }
    return await _authRepository.login(request);
  }
}
