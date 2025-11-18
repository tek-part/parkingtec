import 'package:intl/intl.dart';

/// Date and Time Formatter Utilities
/// Provides helper functions for formatting dates and times
class DateFormatter {
  /// Format date to dd/mm/yyyy
  /// Example: 18/11/2025
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Format time to hh:mm AM/PM
  /// Example: 09:00 AM or 02:30 PM
  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Format date and time to dd/mm/yyyy hh:mm AM/PM
  /// Example: 18/11/2025 09:00 AM
  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  /// Parse API date string to DateTime
  /// Handles nullable strings and ISO 8601 format
  /// Returns null if parsing fails
  static DateTime? parseApiDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Format API date string to dd/mm/yyyy
  /// Returns empty string if date is null or invalid
  static String formatApiDate(String? dateString) {
    final date = parseApiDate(dateString);
    if (date == null) return '';
    return formatDate(date);
  }

  /// Format API date string to hh:mm AM/PM
  /// Returns empty string if date is null or invalid
  static String formatApiTime(String? dateString) {
    final date = parseApiDate(dateString);
    if (date == null) return '';
    return formatTime(date);
  }

  /// Format API date string to dd/mm/yyyy hh:mm AM/PM
  /// Returns empty string if date is null or invalid
  static String formatApiDateTime(String? dateString) {
    final date = parseApiDate(dateString);
    if (date == null) return '';
    return formatDateTime(date);
  }
}

