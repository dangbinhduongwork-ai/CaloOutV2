import 'health_burn_sample.dart';
import 'health_sync_status.dart';

/// Immutable entity containing the outcome of a Health synchronization process.
class HealthSyncResult {
  const HealthSyncResult({
    required this.status,
    this.deduplicatedCalories = 0.0,
    this.totalSteps = 0,
    this.acceptedSamples = const [],
    this.overlappingSamples = const [],
    this.overlappingCaloriesIgnored = 0.0,
    this.platformSourceName = 'Health',
    this.errorMessage,
    this.lastSyncedAt,
  });

  final HealthSyncStatus status;
  final double deduplicatedCalories;
  final int totalSteps;
  final List<HealthBurnSample> acceptedSamples;
  final List<HealthBurnSample> overlappingSamples;
  final double overlappingCaloriesIgnored;
  final String platformSourceName;
  final String? errorMessage;
  final DateTime? lastSyncedAt;

  static const HealthSyncResult disabled = HealthSyncResult(
    status: HealthSyncStatus.disabled,
  );

  HealthSyncResult copyWith({
    HealthSyncStatus? status,
    double? deduplicatedCalories,
    int? totalSteps,
    List<HealthBurnSample>? acceptedSamples,
    List<HealthBurnSample>? overlappingSamples,
    double? overlappingCaloriesIgnored,
    String? platformSourceName,
    String? errorMessage,
    DateTime? lastSyncedAt,
  }) {
    return HealthSyncResult(
      status: status ?? this.status,
      deduplicatedCalories: deduplicatedCalories ?? this.deduplicatedCalories,
      totalSteps: totalSteps ?? this.totalSteps,
      acceptedSamples: acceptedSamples ?? this.acceptedSamples,
      overlappingSamples: overlappingSamples ?? this.overlappingSamples,
      overlappingCaloriesIgnored:
          overlappingCaloriesIgnored ?? this.overlappingCaloriesIgnored,
      platformSourceName: platformSourceName ?? this.platformSourceName,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthSyncResult &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          deduplicatedCalories == other.deduplicatedCalories &&
          totalSteps == other.totalSteps &&
          overlappingCaloriesIgnored == other.overlappingCaloriesIgnored &&
          platformSourceName == other.platformSourceName &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => Object.hash(
        status,
        deduplicatedCalories,
        totalSteps,
        overlappingCaloriesIgnored,
        platformSourceName,
        errorMessage,
      );

  @override
  String toString() =>
      'HealthSyncResult(status: $status, kcal: $deduplicatedCalories, steps: $totalSteps, ignored: $overlappingCaloriesIgnored, source: $platformSourceName)';
}
