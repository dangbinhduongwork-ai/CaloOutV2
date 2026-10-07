import '../entities/activity_entry.dart';
import '../entities/daily_summary.dart';

/// Pure Dart calculator for DailySummary.
///
/// Combines basal metabolism (BMR) with calories from logged exercise activities
/// and deduplicated active energy from Apple Health / Health Connect.
/// Does NOT apply activity multiplier to prevent double-counting.
class DailySummaryCalculator {
  const DailySummaryCalculator._();

  /// Calculate summary from BMR, list of manual entries, and optional Health active calories.
  static DailySummary calculate({
    required double bmr,
    required List<ActivityEntry> entries,
    double healthActiveKcal = 0.0,
    int healthSteps = 0,
  }) {
    final safeBmr = bmr < 0 ? 0.0 : bmr;

    var totalActivityKcal = 0.0;
    for (final entry in entries) {
      if (entry.caloriesBurned > 0) {
        totalActivityKcal += entry.caloriesBurned;
      }
    }

    final safeHealthKcal = healthActiveKcal < 0 ? 0.0 : healthActiveKcal;
    final safeSteps = healthSteps < 0 ? 0 : healthSteps;

    return DailySummary(
      bmr: safeBmr,
      activityKcal: totalActivityKcal,
      healthActiveKcal: safeHealthKcal,
      healthSteps: safeSteps,
      totalKcal: safeBmr + totalActivityKcal + safeHealthKcal,
    );
  }
}
