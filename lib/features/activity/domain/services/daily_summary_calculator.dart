import '../entities/activity_entry.dart';
import '../entities/daily_summary.dart';

/// Pure Dart calculator for DailySummary.
///
/// Combines basal metabolism (BMR) with calories from logged exercise activities.
/// Does NOT apply activity multiplier to prevent double-counting.
class DailySummaryCalculator {
  const DailySummaryCalculator._();

  /// Calculate summary from BMR and list of entries for a day.
  static DailySummary calculate({
    required double bmr,
    required List<ActivityEntry> entries,
  }) {
    final safeBmr = bmr < 0 ? 0.0 : bmr;

    var totalActivityKcal = 0.0;
    for (final entry in entries) {
      if (entry.caloriesBurned > 0) {
        totalActivityKcal += entry.caloriesBurned;
      }
    }

    return DailySummary(
      bmr: safeBmr,
      activityKcal: totalActivityKcal,
      totalKcal: safeBmr + totalActivityKcal,
    );
  }
}
