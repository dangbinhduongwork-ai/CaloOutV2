import '../../../../core/validators/validation_result.dart';

/// Pure Dart validator for activity inputs without throwing exceptions.
///
/// Limits:
/// - Duration: 1 to 600 minutes
/// - MET: 1.0 to 25.0
class ActivityValidator {
  const ActivityValidator._();

  static const int minDurationMinutes = 1;
  static const int maxDurationMinutes = 600;

  static const double minMet = 1.0;
  static const double maxMet = 25.0;

  /// Validate activity duration (1 - 600 minutes)
  static ValidationResult validateDuration(int? durationMinutes) {
    if (durationMinutes == null) {
      return const ValidationResult.invalid(
        'Duration is required',
        fieldName: 'duration',
      );
    }
    if (durationMinutes < minDurationMinutes || durationMinutes > maxDurationMinutes) {
      return const ValidationResult.invalid(
        'Duration must be between 1 and 600 minutes',
        fieldName: 'duration',
      );
    }
    return const ValidationResult.valid();
  }

  /// Validate MET rating (1.0 - 25.0)
  static ValidationResult validateMet(double? met) {
    if (met == null) {
      return const ValidationResult.invalid(
        'MET is required',
        fieldName: 'met',
      );
    }
    if (met < minMet || met > maxMet) {
      return const ValidationResult.invalid(
        'MET must be between 1.0 and 25.0',
        fieldName: 'met',
      );
    }
    return const ValidationResult.valid();
  }

  /// Validate custom activity name
  static ValidationResult validateCustomName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return const ValidationResult.invalid(
        'Custom activity name cannot be empty',
        fieldName: 'customName',
      );
    }
    if (name.trim().length > 100) {
      return const ValidationResult.invalid(
        'Activity name is too long (max 100 characters)',
        fieldName: 'customName',
      );
    }
    return const ValidationResult.valid();
  }
}
