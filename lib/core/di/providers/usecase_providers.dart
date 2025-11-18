import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/di/providers/repository_providers.dart';
import 'package:parkingtec/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:parkingtec/features/auth/domain/usecases/login_usecase.dart';
import 'package:parkingtec/features/auth/domain/usecases/logout_usecase.dart';
import 'package:parkingtec/features/config/domain/usecases/get_app_config_usecase.dart';
import 'package:parkingtec/features/daily/domain/usecases/get_active_daily_usecase.dart';
import 'package:parkingtec/features/daily/domain/usecases/start_daily_usecase.dart';
import 'package:parkingtec/features/daily/domain/usecases/terminate_daily_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/complete_invoice_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/create_invoice_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/get_active_invoices_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/get_all_invoices_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/get_invoice_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/get_pending_invoices_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/pay_invoice_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/pickup_invoice_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/scan_invoice_usecase.dart';
import 'package:parkingtec/features/invoice/domain/usecases/search_invoices_usecase.dart';

/// Use Case Providers

/// Login Use Case provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

/// Get Profile Use Case provider
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.read(authRepositoryProvider));
});

/// Logout Use Case provider
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

/// Get Active Daily Use Case provider
final getActiveDailyUseCaseProvider = Provider<GetActiveDailyUseCase>((ref) {
  return GetActiveDailyUseCase(ref.read(dailyRepositoryProvider));
});

/// Start Daily Use Case provider
final startDailyUseCaseProvider = Provider<StartDailyUseCase>((ref) {
  return StartDailyUseCase(ref.read(dailyRepositoryProvider));
});

/// Terminate Daily Use Case provider
final terminateDailyUseCaseProvider = Provider<TerminateDailyUseCase>((ref) {
  return TerminateDailyUseCase(ref.read(dailyRepositoryProvider));
});

/// Get App Config Use Case provider
final getAppConfigUseCaseProvider = Provider<GetAppConfigUseCase>((ref) {
  return GetAppConfigUseCase(ref.read(configRepositoryProvider));
});

/// Invoice Use Case Providers

/// Get All Invoices Use Case provider
final getAllInvoicesUseCaseProvider = Provider<GetAllInvoicesUseCase>((ref) {
  return GetAllInvoicesUseCase(ref.read(invoiceRepositoryProvider));
});

/// Get Active Invoices Use Case provider
final getActiveInvoicesUseCaseProvider = Provider<GetActiveInvoicesUseCase>((ref) {
  return GetActiveInvoicesUseCase(ref.read(invoiceRepositoryProvider));
});

/// Get Pending Invoices Use Case provider
final getPendingInvoicesUseCaseProvider = Provider<GetPendingInvoicesUseCase>((ref) {
  return GetPendingInvoicesUseCase(ref.read(invoiceRepositoryProvider));
});

/// Get Invoice Use Case provider
final getInvoiceUseCaseProvider = Provider<GetInvoiceUseCase>((ref) {
  return GetInvoiceUseCase(ref.read(invoiceRepositoryProvider));
});

/// Create Invoice Use Case provider
final createInvoiceUseCaseProvider = Provider<CreateInvoiceUseCase>((ref) {
  return CreateInvoiceUseCase(ref.read(invoiceRepositoryProvider));
});

/// Complete Invoice Use Case provider
final completeInvoiceUseCaseProvider = Provider<CompleteInvoiceUseCase>((ref) {
  return CompleteInvoiceUseCase(ref.read(invoiceRepositoryProvider));
});

/// Pay Invoice Use Case provider
final payInvoiceUseCaseProvider = Provider<PayInvoiceUseCase>((ref) {
  return PayInvoiceUseCase(ref.read(invoiceRepositoryProvider));
});

/// Pickup Invoice Use Case provider
final pickupInvoiceUseCaseProvider = Provider<PickupInvoiceUseCase>((ref) {
  return PickupInvoiceUseCase(ref.read(invoiceRepositoryProvider));
});

/// Scan Invoice Use Case provider
final scanInvoiceUseCaseProvider = Provider<ScanInvoiceUseCase>((ref) {
  return ScanInvoiceUseCase(ref.read(invoiceRepositoryProvider));
});

/// Search Invoices Use Case provider
final searchInvoicesUseCaseProvider = Provider<SearchInvoicesUseCase>((ref) {
  return SearchInvoicesUseCase(ref.read(invoiceRepositoryProvider));
});
