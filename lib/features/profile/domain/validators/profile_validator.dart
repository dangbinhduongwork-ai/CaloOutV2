import '../../../../core/validators/validation_result.dart';
import '../entities/user_profile.dart';

/// Pure Dart validator for user profile inputs.
///
/// Limits:
/// - Age: 10 to 100 years
/// - Height: 100.0 to 250.0 cm
/// - Weight: 30.0 to 300.0 kg
class ProfileValidator {
  const ProfileValidator._();

  static const int minAge = 10;
  static const int maxAge = 100;

  static const double minHeightCm = 100.0;
  static const double maxHeightCm = 250.0;

  static const double minWeightKg = 30.0;
  static const double maxWeightKg = 300.0;

  /// Validate age (10 - 100)
  static ValidationResult validateAge(int? age) {
    if (age == null) {
      return const ValidationResult.invalid(
        'Age is required',
        fieldName: 'age',
      );
    }
    if (age < minAge || age > maxAge) {
      return const ValidationResult.invalid(
        'Age must be between 10 and 100',
        fieldName: 'age',
      );
    }
    return const ValidationResult.valid();
  }

  /// Validate height in cm (100.0 - 250.0)
  static ValidationResult validateHeight(double? heightCm) {
    if (heightCm == null) {
      return const ValidationResult.invalid(
        'Height is required',
        fieldName: 'height',
      );
    }
    if (heightCm < minHeightCm || heightCm > maxHeightCm) {
      return const ValidationResult.invalid(
        'Height must be between 100 and 250 cm',
        fieldName: 'height',
      );
    }
    return const ValidationResult.valid();
  }

  /// Validate weight in kg (30.0 - 300.0)
  static ValidationResult validateWeight(double? weightKg) {
    if (weightKg == null) {
      return const ValidationResult.invalid(
        'Weight is required',
        fieldName: 'weight',
      );
    }
    if (weightKg < minWeightKg || weightKg > maxWeightKg) {
      return const ValidationResult.invalid(
        'Weight must be between 30 and 300 kg',
        fieldName: 'weight',
      );
    }
    return const ValidationResult.valid();
  }

  /// Validate entire UserProfile instance
  static ValidationResult validateProfile(UserProfile profile) {
    final ageRes = validateAge(profile.age);
    if (!ageRes.isValid) return ageRes;

    final heightRes = validateHeight(profile.heightCm);
    if (!heightRes.isValid) return heightRes;

    final weightRes = validateWeight(profile.weightKg);
    if (!weightRes.isValid) return weightRes;

    return const ValidationResult.valid();
  }
}
