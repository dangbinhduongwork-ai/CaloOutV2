import '../entities/gender.dart';
import '../entities/user_profile.dart';

/// Pure Dart calculator for Basal Metabolic Rate (BMR) using the Mifflin-St Jeor equation.
///
/// Men:   10 × weight(kg) + 6.25 × height(cm) - 5 × age + 5
/// Women: 10 × weight(kg) + 6.25 × height(cm) - 5 × age - 161
class BmrCalculator {
  const BmrCalculator._();

  /// Calculate BMR from a [UserProfile].
  /// Returns 0.0 if any parameter is non-positive to prevent negative or invalid values.
  static double calculate(UserProfile profile) {
    return calculateRaw(
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
    );
  }

  /// Raw calculation method taking individual parameters.
  static double calculateRaw({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    if (weightKg <= 0 || heightCm <= 0 || age <= 0) {
      return 0.0;
    }

    final base = (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age);
    switch (gender) {
      case Gender.male:
        return base + 5.0;
      case Gender.female:
        return base - 161.0;
    }
  }
}
