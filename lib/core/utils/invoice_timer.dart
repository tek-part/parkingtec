import 'package:parkingtec/features/invoice/data/models/invoice.dart';

/// Invoice Timer Utility
/// Calculates duration and price for hourly invoices
class InvoiceTimer {
  /// Calculate duration from start time to now (or end time)
  static Duration calculateDuration(Invoice invoice) {
    final start = invoice.startDateTime;
    if (start == null) return Duration.zero;

    final end = invoice.endDateTime ?? DateTime.now();
    return end.difference(start);
  }

  /// Calculate hours from duration
  /// If user starts in a new hour, it counts as a full hour
  /// Example: If started at 10:01, it counts as 1.0 hour
  static double calculateHours(Duration duration) {
    // Minimum 0.25 hours (15 minutes)
    final hours = duration.inMinutes / 60.0;
    final roundedHours = hours < 0.25 ? 0.25 : hours;
    // Round up to next hour if started in new hour
    // This means if any time has passed in a new hour, count it as full hour
    return roundedHours.ceil().toDouble();
  }

  /// Calculate current amount for hourly invoice
  static double? calculateCurrentAmount(Invoice invoice) {
    if (!invoice.isHourlyPricing) return null;
    if (invoice.hourlyRate == null) return null;

    final duration = calculateDuration(invoice);
    final hours = calculateHours(duration);
    final amount = invoice.hourlyRate! * hours;

    // Round to 2 decimal places
    return double.parse(amount.toStringAsFixed(2));
  }

  /// Format duration as hours and minutes
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Format duration as hours only (decimal)
  static String formatDurationAsHours(Duration duration) {
    final hours = calculateHours(duration);
    return hours.toStringAsFixed(2);
  }
}

