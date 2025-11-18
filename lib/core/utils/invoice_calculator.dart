import 'package:parkingtec/core/utils/currency_formatter.dart';

/// Invoice calculator utility
/// Calculates invoice amounts based on pricing type
class InvoiceCalculator {
  /// Calculate invoice amount based on pricing type
  ///
  /// For fixed pricing:
  /// - Returns the fixed price directly
  ///
  /// For hourly pricing:
  /// - Calculates: hourlyRate * hours
  /// - Rounds to 2 decimal places
  ///
  /// Returns null if calculation cannot be performed
  static double? calculateAmount({
    required String pricingType,
    double? fixedPrice,
    double? hourlyRate,
    Duration? duration,
  }) {
    if (pricingType == 'fixed') {
      return fixedPrice;
    } else if (pricingType == 'hourly') {
      if (hourlyRate == null || duration == null) {
        return null;
      }

      // Calculate hours from duration
      final hours = duration.inMinutes / 60.0;
      final amount = hourlyRate * hours;

      // Round to 2 decimal places
      return double.parse(amount.toStringAsFixed(2));
    }

    return null;
  }

  /// Calculate amount from start and end times
  /// Convenience method that calculates duration automatically
  static double? calculateAmountFromTimes({
    required String pricingType,
    required DateTime startTime,
    DateTime? endTime,
    double? fixedPrice,
    double? hourlyRate,
  }) {
    final end = endTime ?? DateTime.now();
    final duration = end.difference(startTime);

    return calculateAmount(
      pricingType: pricingType,
      fixedPrice: fixedPrice,
      hourlyRate: hourlyRate,
      duration: duration,
    );
  }

  /// Format calculated amount with currency
  /// Combines calculation and formatting
  static String? formatCalculatedAmount({
    required String pricingType,
    double? fixedPrice,
    double? hourlyRate,
    Duration? duration,
    String? currency,
    String? currencySymbol,
  }) {
    final amount = calculateAmount(
      pricingType: pricingType,
      fixedPrice: fixedPrice,
      hourlyRate: hourlyRate,
      duration: duration,
    );

    if (amount == null) {
      return null;
    }

    return CurrencyFormatter.formatAmount(amount, currency, currencySymbol);
  }
}

