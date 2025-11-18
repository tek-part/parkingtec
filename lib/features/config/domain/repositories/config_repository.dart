import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/domain/entities/app_config_entity.dart';

/// Repository interface for app config operations
/// Defines the contract for application configuration data access
abstract class ConfigRepository {
  /// Get application configuration
  /// Returns Either<Failure, AppConfigEntity>
  Future<Either<Failure, AppConfigEntity>> getAppConfig();
}

