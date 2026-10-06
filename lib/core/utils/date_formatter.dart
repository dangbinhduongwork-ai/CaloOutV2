import 'package:intl/intl.dart';

/// Date formatting helper functions for UI display
class DateFormatter {
  DateFormatter._();

  /// Format date for display: "06/10/2026" or "10/06/2026"
  static String formatFullDate(DateTime date, {String locale = 'vi'}) {
    if (locale == 'vi') {
      return DateFormat('dd/MM/yyyy').format(date);
    }
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format short date: "06/10"
  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  /// Format weekday name
  static String formatWeekday(DateTime date, {String locale = 'vi'}) {
    return DateFormat('E', locale).format(date);
  }

  /// Format time: "14:30"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Check if two DateTimes represent the same calendar day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
