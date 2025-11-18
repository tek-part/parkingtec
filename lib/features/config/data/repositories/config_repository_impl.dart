import 'package:dartz/dartz.dart';
import 'package:parkingtec/core/errors/errors.dart';
import 'package:parkingtec/features/config/data/datasources/config_remote_datasource.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/config/domain/entities/app_config_entity.dart';
import 'package:parkingtec/features/config/domain/repositories/config_repository.dart';

/// Implementation of ConfigRepository
/// Handles app config business logic and data flow
/// Converts ApiResult to Either<Failure, T> for functional error handling
class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigRemoteDataSource _remoteDataSource;

  ConfigRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AppConfigEntity>> getAppConfig() async {
    final result = await _remoteDataSource.getAppConfig();
    return result.toEither().map((config) => _mapModelToEntity(config));
  }

  /// Map AppConfig (Model/DTO) to AppConfigEntity (Domain Entity)
  AppConfigEntity _mapModelToEntity(AppConfig model) {
    return AppConfigEntity(
      barcodeEnabled: model.barcodeEnabled,
      showPrices: model.showPrices,
      pricingType: model.pricingType,
      defaultFixedPrice: model.defaultFixedPrice,
      defaultHourlyRate: model.defaultHourlyRate,
      currency: model.currency,
      currencySymbol: model.currencySymbol,
      systemName: model.systemName,
      logo: model.logo,
    );
  }
}

