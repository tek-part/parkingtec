import 'package:json_annotation/json_annotation.dart';

part 'app_config.g.dart';

/// App Config Model (DTO)
/// Represents application configuration from API
@JsonSerializable()
class AppConfig {
  @JsonKey(name: 'barcode_enabled', defaultValue: false)
  final bool barcodeEnabled;

  @JsonKey(name: 'show_prices', defaultValue: true)
  final bool showPrices;

  @JsonKey(name: 'pricing_type', defaultValue: 'fixed')
  final String pricingType;

  @JsonKey(name: 'default_fixed_price')
  final double? defaultFixedPrice;

  @JsonKey(name: 'default_hourly_rate')
  final double? defaultHourlyRate;

  final String? currency;

  @JsonKey(name: 'currency_symbol')
  final String? currencySymbol;

  @JsonKey(name: 'system_name')
  final String? systemName;

  final String? logo;

  const AppConfig({
    this.barcodeEnabled = false,
    this.showPrices = true,
    this.pricingType = 'fixed',
    this.defaultFixedPrice,
    this.defaultHourlyRate,
    this.currency,
    this.currencySymbol,
    this.systemName,
    this.logo,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);

  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}

