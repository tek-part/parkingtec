import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/domain/entities/app_config_entity.dart';
import 'package:parkingtec/features/config/domain/repositories/config_repository.dart';

/// Use case for getting application configuration
/// Handles the business logic for retrieving app config
class GetAppConfigUseCase {
  final ConfigRepository _configRepository;

  GetAppConfigUseCase(this._configRepository);

  /// Execute get app config use case
  /// Returns Either<Failure, AppConfigEntity>
  Future<Either<Failure, AppConfigEntity>> execute() async {
    return await _configRepository.getAppConfig();
  }
}

