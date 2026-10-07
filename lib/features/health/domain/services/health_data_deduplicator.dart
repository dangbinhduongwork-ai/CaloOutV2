import '../../../activity/domain/entities/activity_entry.dart';
import '../entities/health_burn_sample.dart';

/// Outcome of deduplicating Health active energy samples against manual activity logs.
class DeduplicationResult {
  const DeduplicationResult({
    required this.deduplicatedCalories,
    required this.acceptedSamples,
    required this.overlappingSamples,
    required this.overlappingCaloriesIgnored,
  });

  /// Calories from Health samples that do NOT conflict with any manual workout windows.
  final double deduplicatedCalories;

  /// Health samples kept (occurring outside manual workout times).
  final List<HealthBurnSample> acceptedSamples;

  /// Health samples excluded because they overlap with manual workout times.
  final List<HealthBurnSample> overlappingSamples;

  /// Total calories from excluded samples.
  final double overlappingCaloriesIgnored;

  int get totalSamplesCount => acceptedSamples.length + overlappingSamples.length;
}

/// Pure Dart service to eliminate double-counting between Apple Health/Health Connect
/// and manually logged workout sessions.
class HealthDataDeduplicator {
  const HealthDataDeduplicator._();

  /// Determines if a [HealthBurnSample] overlaps with any manual [ActivityEntry].
  ///
  /// A manual entry occupies the interval:
  /// `[entry.performedAt, entry.performedAt + Duration(minutes: entry.durationMinutes)]`.
  ///
  /// Overlap occurs when:
  /// `sample.dateFrom < manualEnd` AND `sample.effectiveDateTo > manualStart`.
  static bool isOverlapping(
    HealthBurnSample sample,
    List<ActivityEntry> manualEntries,
  ) {
    final sampleFrom = sample.dateFrom;
    final sampleTo = sample.effectiveDateTo;

    for (final entry in manualEntries) {
      final duration = entry.durationMinutes > 0 ? entry.durationMinutes : 1;
      final manualStart = entry.performedAt;
      final manualEnd = manualStart.add(Duration(minutes: duration));

      // Check standard interval intersection:
      // StartA < EndB and EndA > StartB
      if (sampleFrom.isBefore(manualEnd) && sampleTo.isAfter(manualStart)) {
        return true;
      }
    }
    return false;
  }

  /// Deduplicates health samples against manually logged activities.
  ///
  /// Returns a [DeduplicationResult] separating accepted samples from
  /// excluded overlapping samples.
  static DeduplicationResult deduplicate({
    required List<HealthBurnSample> samples,
    required List<ActivityEntry> manualEntries,
  }) {
    final accepted = <HealthBurnSample>[];
    final overlapping = <HealthBurnSample>[];
    var deduplicatedKcal = 0.0;
    var ignoredKcal = 0.0;

    for (final sample in samples) {
      // Discard invalid / non-positive calorie values
      if (sample.caloriesBurned <= 0) continue;

      if (isOverlapping(sample, manualEntries)) {
        overlapping.add(sample);
        ignoredKcal += sample.caloriesBurned;
      } else {
        accepted.add(sample);
        deduplicatedKcal += sample.caloriesBurned;
      }
    }

    return DeduplicationResult(
      deduplicatedCalories: deduplicatedKcal,
      acceptedSamples: List.unmodifiable(accepted),
      overlappingSamples: List.unmodifiable(overlapping),
      overlappingCaloriesIgnored: ignoredKcal,
    );
  }
}
