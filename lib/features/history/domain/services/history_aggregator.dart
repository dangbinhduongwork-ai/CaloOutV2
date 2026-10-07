import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/daily_summary.dart';
import 'package:caloout/features/history/domain/entities/day_burn_record.dart';
import 'package:caloout/features/history/domain/entities/history_period_summary.dart';
import 'package:caloout/features/history/domain/entities/history_range_type.dart';

/// Pure Dart aggregator for calorie burn history across date ranges.
class HistoryAggregator {
  const HistoryAggregator._();

  /// Aggregates activity entries across a range [start] to [end] (inclusive).
  /// Every day in the range is present, even with 0 activities (where total = BMR).
  static HistoryPeriodSummary aggregate({
    required double bmr,
    required DateTime start,
    required DateTime end,
    required List<ActivityEntry> entries,
    HistoryRangeType rangeType = HistoryRangeType.week,
  }) {
    final safeBmr = bmr < 0 ? 0.0 : bmr;
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);

    if (normalizedStart.isAfter(normalizedEnd)) {
      return HistoryPeriodSummary(
        startDate: normalizedStart,
        endDate: normalizedEnd,
        rangeType: rangeType,
        dailyRecords: const [],
        totalKcal: 0.0,
        averageDailyKcal: 0.0,
        totalActivityKcal: 0.0,
        totalActiveMinutes: 0,
        highestDay: null,
        lowestDay: null,
      );
    }

    // Group entries by 'YYYY-MM-DD'
    final Map<String, List<ActivityEntry>> entriesByDate = {};
    for (final entry in entries) {
      final key = _dateKey(entry.performedAt);
      entriesByDate.putIfAbsent(key, () => []).add(entry);
    }

    final records = <DayBurnRecord>[];
    var current = normalizedStart;

    while (!current.isAfter(normalizedEnd)) {
      final key = _dateKey(current);
      final dayEntries = entriesByDate[key] ?? const [];

      var dayActivityKcal = 0.0;
      var dayActiveMinutes = 0;

      for (final item in dayEntries) {
        if (item.caloriesBurned > 0) {
          dayActivityKcal += item.caloriesBurned;
        }
        if (item.durationMinutes > 0) {
          dayActiveMinutes += item.durationMinutes;
        }
      }

      records.add(
        DayBurnRecord(
          date: current,
          bmr: safeBmr,
          activityKcal: dayActivityKcal,
          totalKcal: safeBmr + dayActivityKcal,
          activeMinutes: dayActiveMinutes,
          entries: dayEntries,
        ),
      );

      // Safe leap/month crossing increment
      current = DateTime(current.year, current.month, current.day + 1);
    }

    var totalKcal = 0.0;
    var totalActivityKcal = 0.0;
    var totalActiveMinutes = 0;
    DayBurnRecord? highest;
    DayBurnRecord? lowest;

    for (final rec in records) {
      totalKcal += rec.totalKcal;
      totalActivityKcal += rec.activityKcal;
      totalActiveMinutes += rec.activeMinutes;

      if (highest == null || rec.totalKcal > highest.totalKcal) {
        highest = rec;
      }
      if (lowest == null || rec.totalKcal < lowest.totalKcal) {
        lowest = rec;
      }
    }

    final avgDaily = records.isNotEmpty ? totalKcal / records.length : 0.0;

    return HistoryPeriodSummary(
      startDate: normalizedStart,
      endDate: normalizedEnd,
      rangeType: rangeType,
      dailyRecords: List.unmodifiable(records),
      totalKcal: totalKcal,
      averageDailyKcal: avgDaily,
      totalActivityKcal: totalActivityKcal,
      totalActiveMinutes: totalActiveMinutes,
      highestDay: highest,
      lowestDay: lowest,
    );
  }

  /// Calculates Monday-to-Sunday range containing [anchor]
  static ({DateTime start, DateTime end}) getWeekRange(DateTime anchor) {
    final monday = DateTime(
      anchor.year,
      anchor.month,
      anchor.day - (anchor.weekday - 1),
    );
    final sunday = DateTime(monday.year, monday.month, monday.day + 6);
    return (start: monday, end: sunday);
  }

  /// Calculates Month range (1st to last day: 28/29/30/31) containing [anchor]
  static ({DateTime start, DateTime end}) getMonthRange(DateTime anchor) {
    final firstDay = DateTime(anchor.year, anchor.month, 1);
    final lastDay = DateTime(anchor.year, anchor.month + 1, 0);
    return (start: firstDay, end: lastDay);
  }

  /// Calculates single day range containing [anchor]
  static ({DateTime start, DateTime end}) getDayRange(DateTime anchor) {
    final day = DateTime(anchor.year, anchor.month, anchor.day);
    return (start: day, end: day);
  }

  /// Returns a list of [DailySummary] for each calendar day in [start] to [end] (inclusive).
  /// Days without activity have activityKcal = 0 and totalKcal = BMR.
  static List<DailySummary> aggregateDailySummaries({
    required double bmr,
    required DateTime start,
    required DateTime end,
    required List<ActivityEntry> entries,
  }) {
    final summary = aggregate(
      bmr: bmr,
      start: start,
      end: end,
      entries: entries,
    );
    return summary.dailySummaries;
  }

  /// Calculates total calories burned across a list of daily summaries.
  static double calculateTotal(List<DailySummary> summaries) {
    var total = 0.0;
    for (final s in summaries) {
      total += s.totalKcal;
    }
    return total;
  }

  /// Calculates average daily calories burned across a list of daily summaries.
  static double calculateAverage(List<DailySummary> summaries) {
    if (summaries.isEmpty) return 0.0;
    return calculateTotal(summaries) / summaries.length;
  }

  /// Finds the daily summary with the highest total calories burned.
  static DailySummary? findHighest(List<DailySummary> summaries) {
    if (summaries.isEmpty) return null;
    DailySummary? highest;
    for (final s in summaries) {
      if (highest == null || s.totalKcal > highest.totalKcal) {
        highest = s;
      }
    }
    return highest;
  }

  /// Finds the daily summary with the lowest total calories burned.
  static DailySummary? findLowest(List<DailySummary> summaries) {
    if (summaries.isEmpty) return null;
    DailySummary? lowest;
    for (final s in summaries) {
      if (lowest == null || s.totalKcal < lowest.totalKcal) {
        lowest = s;
      }
    }
    return lowest;
  }

  static String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}
