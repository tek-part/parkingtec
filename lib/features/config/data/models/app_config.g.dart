// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
      barcodeEnabled: json['barcode_enabled'] as bool? ?? false,
      showPrices: json['show_prices'] as bool? ?? true,
      pricingType: json['pricing_type'] as String? ?? 'fixed',
      defaultFixedPrice: (json['default_fixed_price'] as num?)?.toDouble(),
      defaultHourlyRate: (json['default_hourly_rate'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      systemName: json['system_name'] as String?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
      'barcode_enabled': instance.barcodeEnabled,
      'show_prices': instance.showPrices,
      'pricing_type': instance.pricingType,
      'default_fixed_price': instance.defaultFixedPrice,
      'default_hourly_rate': instance.defaultHourlyRate,
      'currency': instance.currency,
      'currency_symbol': instance.currencySymbol,
      'system_name': instance.systemName,
      'logo': instance.logo,
    };
