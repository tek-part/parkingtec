import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/core_providers.dart';
import 'package:parkingtec/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:parkingtec/features/config/data/datasources/config_remote_datasource.dart';
import 'package:parkingtec/features/daily/data/datasources/daily_remote_datasource.dart';
import 'package:parkingtec/features/invoice/data/datasources/invoice_remote_datasource.dart';

/// Data Source Providers

/// Auth Remote Data Source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRemoteDataSourceImpl(apiService);
});

/// Daily Remote Data Source provider
final dailyRemoteDataSourceProvider = Provider<DailyRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return DailyRemoteDataSourceImpl(apiService);
});

/// Invoice Remote Data Source provider
final invoiceRemoteDataSourceProvider = Provider<InvoiceRemoteDataSource>((
  ref,
) {
  final apiService = ref.watch(apiServiceProvider);
  return InvoiceRemoteDataSourceImpl(apiService);
});

/// Config Remote Data Source provider
final configRemoteDataSourceProvider = Provider<ConfigRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ConfigRemoteDataSourceImpl(apiService);
});
