import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/datasource_providers.dart';
import 'package:parkingtec/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:parkingtec/features/auth/domain/repositories/auth_repository.dart';
import 'package:parkingtec/features/config/data/repositories/config_repository_impl.dart';
import 'package:parkingtec/features/config/domain/repositories/config_repository.dart';
import 'package:parkingtec/features/daily/data/repositories/daily_repository_impl.dart';
import 'package:parkingtec/features/daily/domain/repositories/daily_repository.dart';
import 'package:parkingtec/features/invoice/data/repositories/invoice_repository_impl.dart';
import 'package:parkingtec/features/invoice/domain/repositories/invoice_repository.dart';

/// Repository Providers

/// Auth Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

/// Daily Repository provider
final dailyRepositoryProvider = Provider<DailyRepository>((ref) {
  return DailyRepositoryImpl(ref.read(dailyRemoteDataSourceProvider));
});

/// Invoice Repository provider
final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(ref.read(invoiceRemoteDataSourceProvider));
});

/// Config Repository provider
final configRepositoryProvider = Provider<ConfigRepository>((ref) {
  return ConfigRepositoryImpl(ref.read(configRemoteDataSourceProvider));
});
