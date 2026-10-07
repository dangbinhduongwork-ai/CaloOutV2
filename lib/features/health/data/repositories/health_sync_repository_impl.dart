import 'dart:io' show Platform;
import 'package:health/health.dart';
import '../../domain/entities/health_burn_sample.dart';
import '../../domain/repositories/health_sync_repository.dart';

/// Concrete implementation of [HealthSyncRepository] using the official `health` package.
/// Guarantees strictly READ-ONLY interactions with Apple HealthKit and Google Health Connect.
class HealthSyncRepositoryImpl implements HealthSyncRepository {
  HealthSyncRepositoryImpl({Health? healthClient})
      : _health = healthClient ?? Health();

  final Health _health;
  bool _isConfigured = false;

  static const List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  static const List<HealthDataAccess> _readOnlyPermissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  Future<void> _ensureConfigured() async {
    if (!_isConfigured) {
      try {
        await _health.configure();
      } catch (_) {
        // Ignored if platform channels are unavailable
      }
      _isConfigured = true;
    }
  }

  @override
  String get platformSourceName {
    try {
      if (Platform.isIOS) return 'Apple Health';
      if (Platform.isAndroid) return 'Health Connect';
    } catch (_) {
      // Fallback for non-dart:io environments
    }
    return 'Health';
  }

  @override
  Future<HealthAvailabilityStatus> checkAvailability() async {
    try {
      if (!Platform.isIOS && !Platform.isAndroid) {
        return HealthAvailabilityStatus.notSupported;
      }

      await _ensureConfigured();

      if (Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status == HealthConnectSdkStatus.sdkAvailable) {
          return HealthAvailabilityStatus.available;
        } else if (status == HealthConnectSdkStatus.sdkUnavailable ||
            status == HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
          return HealthAvailabilityStatus.notInstalled;
        }
        return HealthAvailabilityStatus.notSupported;
      }

      // iOS HealthKit is available on iPhone devices
      return HealthAvailabilityStatus.available;
    } catch (_) {
      return HealthAvailabilityStatus.notSupported;
    }
  }

  @override
  Future<bool> requestReadAuthorization() async {
    try {
      await _ensureConfigured();
      final granted = await _health.requestAuthorization(
        _dataTypes,
        permissions: _readOnlyPermissions,
      );
      return granted;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasPermissions() async {
    try {
      await _ensureConfigured();
      final has = await _health.hasPermissions(
        _dataTypes,
        permissions: _readOnlyPermissions,
      );
      return has ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<HealthBurnSample>> getSamples({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      await _ensureConfigured();
      final dataPoints = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startTime,
        endTime: endTime,
      );

      final samples = <HealthBurnSample>[];
      for (final point in dataPoints) {
        double calories = 0.0;
        final val = point.value;
        if (val is NumericHealthValue) {
          calories = val.numericValue.toDouble();
        }

        if (calories > 0) {
          samples.add(
            HealthBurnSample(
              id: point.uuid,
              dateFrom: point.dateFrom,
              dateTo: point.dateTo,
              caloriesBurned: calories,
              sourceName: point.sourceName.isNotEmpty
                  ? point.sourceName
                  : platformSourceName,
            ),
          );
        }
      }
      return samples;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<int?> getTotalSteps({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      await _ensureConfigured();
      final steps = await _health.getTotalStepsInInterval(startTime, endTime);
      return steps;
    } catch (_) {
      return null;
    }
  }
}
