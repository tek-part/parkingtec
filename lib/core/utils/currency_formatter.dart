/// Currency formatter utility
/// Formats amounts with currency symbol
class CurrencyFormatter {
  /// Format amount with currency symbol
  /// Example: formatAmount(100.5, "EGP") => "100.50 EGP"
  /// Example: formatAmount(100.5, null, "£") => "£100.50"
  static String formatAmount(
    double amount, [
    String? currency,
    String? currencySymbol,
  ]) {
    final formattedAmount = amount.toStringAsFixed(2);
    final symbol = currencySymbol ?? currency ?? '';

    if (symbol.isEmpty) {
      return formattedAmount;
    }

    // If symbol is a prefix (like $, £, €), put it before amount
    if (_isPrefixSymbol(symbol)) {
      return '$symbol$formattedAmount';
    }

    // Otherwise, put currency after amount
    return '$formattedAmount $symbol';
  }

  /// Check if symbol is a prefix symbol (appears before amount)
  static bool _isPrefixSymbol(String symbol) {
    final prefixSymbols = ['\$', '£', '€', '¥', '₹', '₽', '₩', '₪', '₦', '₨'];
    return prefixSymbols.contains(symbol);
  }

  /// Format amount with currency from provider
  /// This is a convenience method that can be used with Riverpod providers
  static String formatAmountWithProvider(
    double amount,
    String? currency,
    String? currencySymbol,
  ) {
    return formatAmount(amount, currency, currencySymbol);
  }
}

