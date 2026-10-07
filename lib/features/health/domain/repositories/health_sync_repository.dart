import '../entities/health_burn_sample.dart';

/// Platform availability of the Health service.
enum HealthAvailabilityStatus {
  /// Health service is available and ready for authorization.
  available,

  /// Health Connect is not installed on this Android device.
  notInstalled,

  /// Platform or device hardware does not support Health services.
  notSupported,
}

/// Abstract interface for querying HealthKit (iOS) and Health Connect (Android).
/// Strictly READ-ONLY. No write capabilities.
abstract interface class HealthSyncRepository {
  /// Name of the native platform health provider ('Apple Health' on iOS, 'Health Connect' on Android).
  String get platformSourceName;

  /// Checks if Health services are available on the current device.
  Future<HealthAvailabilityStatus> checkAvailability();

  /// Requests READ-ONLY permission from the user for active calories burned and steps.
  Future<bool> requestReadAuthorization();

  /// Checks if READ permissions are currently granted.
  Future<bool> hasPermissions();

  /// Fetches raw active calorie burn samples within the specified date-time interval.
  Future<List<HealthBurnSample>> getSamples({
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Fetches the total step count within the specified date-time interval.
  Future<int?> getTotalSteps({
    required DateTime startTime,
    required DateTime endTime,
  });
}
