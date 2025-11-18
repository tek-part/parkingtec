import 'package:parkingtec/core/errors/api_result.dart';
import 'package:parkingtec/core/errors/exception_mapper.dart';
import 'package:parkingtec/core/services/api_service.dart';
import 'package:parkingtec/features/daily/data/models/daily.dart';
import 'package:parkingtec/features/daily/data/models/requests/start_daily_request.dart';
import 'package:parkingtec/features/daily/data/models/requests/terminate_daily_request.dart';

/// Remote data source for daily operations
/// Handles all API calls related to daily shifts
abstract class DailyRemoteDataSource {
  Future<ApiResult<Daily?>> getActiveDaily();
  Future<ApiResult<Daily>> startDaily(StartDailyRequest request);
  Future<ApiResult<Daily>> terminateDaily(TerminateDailyRequest request);
}

class DailyRemoteDataSourceImpl implements DailyRemoteDataSource {
  final ApiService _apiService;

  DailyRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResult<Daily?>> getActiveDaily() async {
    try {
      final response = await _apiService.getActiveDaily();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Daily>> startDaily(StartDailyRequest request) async {
    try {
      final response = await _apiService.startDaily(request);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }

  @override
  Future<ApiResult<Daily>> terminateDaily(
    TerminateDailyRequest request,
  ) async {
    try {
      final response = await _apiService.terminateDaily(request);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ExceptionMapper.toFailure(e));
    }
  }
}
