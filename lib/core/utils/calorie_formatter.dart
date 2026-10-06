import 'package:intl/intl.dart';

/// Formatting utilities for calories and numbers for presentation.
/// Calculations always keep pure double precision; this class handles display formatting.
class CalorieFormatter {
  const CalorieFormatter._();

  /// Format calorie number with optional decimal places and thousands separator.
  /// Example: 1648.75 with 0 decimal places -> "1,649"
  static String format(double kcal, {int decimalPlaces = 0, String locale = 'en_US'}) {
    final pattern = decimalPlaces > 0
        ? '#,##0.${'0' * decimalPlaces}'
        : '#,##0';
    final formatter = NumberFormat(pattern, locale);
    return formatter.format(kcal);
  }

  /// Format calorie number with unit appended
  /// Example: 2555.56 -> "2,556 kcal"
  static String formatWithUnit(
    double kcal, {
    String unit = 'kcal',
    int decimalPlaces = 0,
    String locale = 'en_US',
  }) {
    return '${format(kcal, decimalPlaces: decimalPlaces, locale: locale)} $unit';
  }
}
