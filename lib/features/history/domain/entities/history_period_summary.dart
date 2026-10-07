import 'package:caloout/features/activity/domain/entities/daily_summary.dart';
import 'day_burn_record.dart';
import 'history_range_type.dart';

/// Aggregated statistical summary for a specified date range (day, week, or month).
class HistoryPeriodSummary {
  const HistoryPeriodSummary({
    required this.startDate,
    required this.endDate,
    required this.rangeType,
    required this.dailyRecords,
    required this.totalKcal,
    required this.averageDailyKcal,
    required this.totalActivityKcal,
    required this.totalActiveMinutes,
    this.highestDay,
    this.lowestDay,
  });

  final DateTime startDate;
  final DateTime endDate;
  final HistoryRangeType rangeType;
  final List<DayBurnRecord> dailyRecords;
  final double totalKcal;
  final double averageDailyKcal;
  final double totalActivityKcal;
  final int totalActiveMinutes;
  final DayBurnRecord? highestDay;
  final DayBurnRecord? lowestDay;

  int get daysCount => dailyRecords.length;

  /// Returns daily summaries as pure DailySummary entities.
  List<DailySummary> get dailySummaries =>
      dailyRecords.map((r) => r.toDailySummary()).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryPeriodSummary &&
          runtimeType == other.runtimeType &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          rangeType == other.rangeType &&
          totalKcal == other.totalKcal &&
          averageDailyKcal == other.averageDailyKcal &&
          totalActivityKcal == other.totalActivityKcal &&
          totalActiveMinutes == other.totalActiveMinutes;

  @override
  int get hashCode => Object.hash(
        startDate,
        endDate,
        rangeType,
        totalKcal,
        averageDailyKcal,
        totalActivityKcal,
        totalActiveMinutes,
      );

  @override
  String toString() =>
      'HistoryPeriodSummary(start: $startDate, end: $endDate, days: ${dailyRecords.length}, '
      'totalKcal: $totalKcal, avgDaily: $averageDailyKcal, highest: ${highestDay?.totalKcal})';
}
