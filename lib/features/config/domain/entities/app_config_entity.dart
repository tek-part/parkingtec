/// App Config Entity
/// Immutable domain object representing application configuration
class AppConfigEntity {
  final bool barcodeEnabled;
  final bool showPrices;
  final String pricingType;
  final double? defaultFixedPrice;
  final double? defaultHourlyRate;
  final String? currency;
  final String? currencySymbol;
  final String? systemName;
  final String? logo;

  const AppConfigEntity({
    required this.barcodeEnabled,
    required this.showPrices,
    required this.pricingType,
    this.defaultFixedPrice,
    this.defaultHourlyRate,
    this.currency,
    this.currencySymbol,
    this.systemName,
    this.logo,
  });

  /// Check if pricing type is fixed
  bool get isFixedPricing => pricingType == 'fixed';

  /// Check if pricing type is hourly
  bool get isHourlyPricing => pricingType == 'hourly';

  /// Check if logo exists
  bool get hasLogo => logo != null && logo!.isNotEmpty;

  /// Get default price based on pricing type
  double? get defaultPrice => isFixedPricing ? defaultFixedPrice : defaultHourlyRate;

  /// Get currency display text
  String get currencyDisplay => currencySymbol ?? currency ?? '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigEntity &&
          runtimeType == other.runtimeType &&
          barcodeEnabled == other.barcodeEnabled &&
          showPrices == other.showPrices &&
          pricingType == other.pricingType &&
          defaultFixedPrice == other.defaultFixedPrice &&
          defaultHourlyRate == other.defaultHourlyRate &&
          currency == other.currency &&
          currencySymbol == other.currencySymbol &&
          systemName == other.systemName &&
          logo == other.logo;

  @override
  int get hashCode =>
      barcodeEnabled.hashCode ^
      showPrices.hashCode ^
      pricingType.hashCode ^
      defaultFixedPrice.hashCode ^
      defaultHourlyRate.hashCode ^
      currency.hashCode ^
      currencySymbol.hashCode ^
      systemName.hashCode ^
      logo.hashCode;
}

