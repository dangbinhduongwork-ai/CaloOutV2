import '../entities/activity_level.dart';

/// Pure Dart calculator for Total Daily Energy Expenditure (TDEE).
///
/// Formula: TDEE = BMR × ActivityLevel.multiplier
class TdeeCalculator {
  const TdeeCalculator._();

  /// Calculates TDEE from BMR and ActivityLevel.
  /// If BMR is non-positive, returns 0.0.
  static double calculate(double bmr, ActivityLevel activityLevel) {
    if (bmr <= 0) {
      return 0.0;
    }
    return bmr * activityLevel.multiplier;
  }
}
