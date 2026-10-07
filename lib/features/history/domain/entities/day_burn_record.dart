import '../../activity/domain/entities/activity_entry.dart';
import '../../activity/domain/entities/daily_summary.dart';

/// Immutable representation of total calorie burn for a single calendar day.
class DayBurnRecord {
  const DayBurnRecord({
    required this.date,
    required this.bmr,
    required this.activityKcal,
    required this.totalKcal,
    required this.activeMinutes,
    required this.entries,
  });

  final DateTime date;
  final double bmr;
  final double activityKcal;
  final double totalKcal;
  final int activeMinutes;
  final List<ActivityEntry> entries;

  bool get hasActivities => entries.isNotEmpty;

  /// Converts this record to a pure DailySummary entity.
  DailySummary toDailySummary() => DailySummary(
        bmr: bmr,
        activityKcal: activityKcal,
        totalKcal: totalKcal,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayBurnRecord &&
          runtimeType == other.runtimeType &&
          date.year == other.date.year &&
          date.month == other.date.month &&
          date.day == other.date.day &&
          bmr == other.bmr &&
          activityKcal == other.activityKcal &&
          totalKcal == other.totalKcal &&
          activeMinutes == other.activeMinutes;

  @override
  int get hashCode => Object.hash(
        date.year,
        date.month,
        date.day,
        bmr,
        activityKcal,
        totalKcal,
        activeMinutes,
      );

  @override
  String toString() =>
      'DayBurnRecord(date: $date, bmr: $bmr, activityKcal: $activityKcal, totalKcal: $totalKcal, activeMinutes: $activeMinutes)';
}
