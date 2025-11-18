import 'package:parkingtec/core/errors/api_result.dart';
import 'package:parkingtec/core/errors/exception_mapper.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/core/services/api_service.dart';
import 'package:parkingtec/features/config/data/models/app_config.dart';
import 'package:parkingtec/features/config/data/models/responses/get_app_config_response.dart';

/// Remote data source for app config operations
/// Handles all API calls related to application configuration
abstract class ConfigRemoteDataSource {
  Future<ApiResult<AppConfig>> getAppConfig();
}

class ConfigRemoteDataSourceImpl implements ConfigRemoteDataSource {
  final ApiService _apiService;

  ConfigRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResult<AppConfig>> getAppConfig() async {
    try {
      final response = await _apiService.getAppConfig();
      // Extract config from GetAppConfigResponse
      if (response.config == null) {
        return ApiResult.failure(
          const ServerFailure('Config data not found in response'),
        );
      }
      return ApiResult.success(response.config!);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }
}

