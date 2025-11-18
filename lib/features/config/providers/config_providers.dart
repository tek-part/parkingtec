import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parkingtec/core/errors/failure.dart';
import 'package:parkingtec/features/config/domain/entities/app_config_entity.dart';
import 'package:parkingtec/features/config/presentation/controllers/config_controller.dart';
import 'package:parkingtec/features/config/presentation/states/config_state.dart';

/// Config Controller Provider
/// Manages app config state using StateNotifier
/// Note: NOT using autoDispose to keep config available throughout app lifecycle
final configControllerProvider =
    StateNotifierProvider<ConfigController, ConfigState>(
  (ref) => ConfigController(ref),
);

/// App Config Entity Provider (Global - without autoDispose)
/// Provides access to current app config from anywhere in the app
final appConfigProvider = Provider<AppConfigEntity?>((ref) {
  return ref.watch(configControllerProvider).maybeWhen(
        loaded: (config) => config,
        orElse: () => null,
      );
});

/// Pricing Type Provider (Global - without autoDispose)
/// Returns pricing type: "fixed" or "hourly"
final pricingTypeProvider = Provider<String?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.pricingType;
});

/// Currency Provider (Global - without autoDispose)
/// Returns currency name
final currencyProvider = Provider<String?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.currency;
});

/// Currency Symbol Provider (Global - without autoDispose)
/// Returns currency symbol for display
final currencySymbolProvider = Provider<String?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.currencySymbol;
});

/// Default Fixed Price Provider (Global - without autoDispose)
/// Returns default fixed price for fixed pricing type
final defaultFixedPriceProvider = Provider<double?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.defaultFixedPrice;
});

/// Default Hourly Rate Provider (Global - without autoDispose)
/// Returns default hourly rate for hourly pricing type
final defaultHourlyRateProvider = Provider<double?>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.defaultHourlyRate;
});

/// Barcode Enabled Provider (Global - without autoDispose)
/// Returns whether barcode scanning is enabled
final barcodeEnabledProvider = Provider<bool>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.barcodeEnabled ?? false;
});

/// Show Prices Provider (Global - without autoDispose)
/// Returns whether prices should be displayed
final showPricesProvider = Provider<bool>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.showPrices ?? true;
});

/// Config Loading Provider
/// Returns true if config is currently loading
final configLoadingProvider = Provider<bool>((ref) {
  return ref.watch(configControllerProvider).maybeWhen(
        loading: () => true,
        orElse: () => false,
      );
});

/// Config Error Provider
/// Returns error failure if config loading failed
final configErrorProvider = Provider<Failure?>((ref) {
  return ref.watch(configControllerProvider).maybeWhen(
        error: (failure) => failure,
        orElse: () => null,
      );
});

/// Is Fixed Pricing Provider (Helper)
/// Returns true if pricing type is "fixed"
final isFixedPricingProvider = Provider<bool>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.isFixedPricing ?? true;
});

/// Is Hourly Pricing Provider (Helper)
/// Returns true if pricing type is "hourly"
final isHourlyPricingProvider = Provider<bool>((ref) {
  final config = ref.watch(appConfigProvider);
  return config?.isHourlyPricing ?? false;
});
