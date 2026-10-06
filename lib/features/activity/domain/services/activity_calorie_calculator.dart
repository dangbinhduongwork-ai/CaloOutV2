/// Pure Dart calculator for calories burned during physical activities.
///
/// Formula: Calories = MET × weight(kg) × duration(hours)
///          Calories = MET × weight(kg) × (durationMinutes / 60.0)
class ActivityCalorieCalculator {
  const ActivityCalorieCalculator._();

  /// Calculates calories burned.
  /// Safely returns 0.0 for non-positive or invalid inputs to avoid crash.
  static double calculate({
    required double met,
    required double weightKg,
    required int durationMinutes,
  }) {
    if (met <= 0.0 || weightKg <= 0.0 || durationMinutes <= 0) {
      return 0.0;
    }

    final hours = durationMinutes / 60.0;
    return met * weightKg * hours;
  }
}
