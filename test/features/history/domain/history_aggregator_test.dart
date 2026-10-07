import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/activity/domain/entities/daily_summary.dart';
import 'package:caloout/features/history/domain/entities/history_range_type.dart';
import 'package:caloout/features/history/domain/services/history_aggregator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const bmr = 1500.0;
  const sampleActivity = ActivityType(
    id: 'run',
    nameKey: 'running',
    met: 8.0,
    category: 'cardio',
  );

  group('HistoryAggregator - Empty & Edge Ranges', () {
    test('returns empty period summary when start date is after end date', () {
      final start = DateTime(2026, 10, 10);
      final end = DateTime(2026, 10, 5);

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: start,
        end: end,
        entries: const [],
      );

      expect(summary.dailyRecords, isEmpty);
      expect(summary.dailySummaries, isEmpty);
      expect(summary.totalKcal, 0.0);
      expect(summary.averageDailyKcal, 0.0);
      expect(summary.highestDay, isNull);
      expect(summary.lowestDay, isNull);

      final dailySummaries = HistoryAggregator.aggregateDailySummaries(
        bmr: bmr,
        start: start,
        end: end,
        entries: const [],
      );
      expect(dailySummaries, isEmpty);
    });

    test('handles single day range correctly', () {
      final date = DateTime(2026, 10, 7);
      final entry = ActivityEntry(
        id: '1',
        activityType: sampleActivity,
        durationMinutes: 30,
        caloriesBurned: 240.0,
        weightKgSnapshot: 70.0,
        performedAt: DateTime(2026, 10, 7, 10, 0),
      );

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: date,
        end: date,
        entries: [entry],
        rangeType: HistoryRangeType.day,
      );

      expect(summary.dailyRecords.length, 1);
      expect(summary.dailyRecords.first.date.day, 7);
      expect(summary.dailyRecords.first.activityKcal, 240.0);
      expect(summary.dailyRecords.first.totalKcal, 1740.0);
      expect(summary.totalKcal, 1740.0);
      expect(summary.averageDailyKcal, 1740.0);
      expect(summary.highestDay?.totalKcal, 1740.0);
      expect(summary.lowestDay?.totalKcal, 1740.0);
    });
  });

  group('HistoryAggregator - Missing Data Days', () {
    test('populates all days in range with BMR when no activity is logged', () {
      final start = DateTime(2026, 10, 1);
      final end = DateTime(2026, 10, 5);

      // Only Oct 2 and Oct 4 have logged activities
      final entries = [
        ActivityEntry(
          id: 'e1',
          activityType: sampleActivity,
          durationMinutes: 45,
          caloriesBurned: 350.0,
          weightKgSnapshot: 70.0,
          performedAt: DateTime(2026, 10, 2, 7, 30),
        ),
        ActivityEntry(
          id: 'e2',
          activityType: sampleActivity,
          durationMinutes: 60,
          caloriesBurned: 500.0,
          weightKgSnapshot: 70.0,
          performedAt: DateTime(2026, 10, 4, 18, 0),
        ),
      ];

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: start,
        end: end,
        entries: entries,
      );

      expect(summary.dailyRecords.length, 5);

      // Oct 1 (No activity: activityKcal = 0, total = BMR)
      expect(summary.dailyRecords[0].date.day, 1);
      expect(summary.dailyRecords[0].activityKcal, 0.0);
      expect(summary.dailyRecords[0].totalKcal, bmr);
      expect(summary.dailyRecords[0].hasActivities, isFalse);

      // Oct 2 (Has activity)
      expect(summary.dailyRecords[1].date.day, 2);
      expect(summary.dailyRecords[1].activityKcal, 350.0);
      expect(summary.dailyRecords[1].totalKcal, bmr + 350.0);
      expect(summary.dailyRecords[1].hasActivities, isTrue);

      // Oct 3 (No activity)
      expect(summary.dailyRecords[2].date.day, 3);
      expect(summary.dailyRecords[2].activityKcal, 0.0);
      expect(summary.dailyRecords[2].totalKcal, bmr);

      // Oct 4 (Has activity)
      expect(summary.dailyRecords[3].date.day, 4);
      expect(summary.dailyRecords[3].activityKcal, 500.0);
      expect(summary.dailyRecords[3].totalKcal, bmr + 500.0);

      // Oct 5 (No activity)
      expect(summary.dailyRecords[4].date.day, 5);
      expect(summary.dailyRecords[4].activityKcal, 0.0);
      expect(summary.dailyRecords[4].totalKcal, bmr);

      // Statistical aggregates
      const expectedTotal = (bmr * 5) + 350.0 + 500.0;
      expect(summary.totalKcal, expectedTotal);
      expect(summary.averageDailyKcal, expectedTotal / 5);
      expect(summary.highestDay?.date.day, 4);
      expect(summary.highestDay?.totalKcal, bmr + 500.0);
      expect(summary.lowestDay?.totalKcal, bmr);
    });
  });

  group('HistoryAggregator - Week Ranges (Monday to Sunday)', () {
    test('getWeekRange computes Monday to Sunday regardless of weekday anchor', () {
      // Wednesday anchor (2026-10-07)
      final wednesday = DateTime(2026, 10, 7);
      final weekRangeWed = HistoryAggregator.getWeekRange(wednesday);
      expect(weekRangeWed.start, DateTime(2026, 10, 5)); // Monday
      expect(weekRangeWed.end, DateTime(2026, 10, 11)); // Sunday

      // Monday anchor (2026-10-05)
      final weekRangeMon = HistoryAggregator.getWeekRange(DateTime(2026, 10, 5));
      expect(weekRangeMon.start, DateTime(2026, 10, 5));
      expect(weekRangeMon.end, DateTime(2026, 10, 11));

      // Sunday anchor (2026-10-11)
      final weekRangeSun = HistoryAggregator.getWeekRange(DateTime(2026, 10, 11));
      expect(weekRangeSun.start, DateTime(2026, 10, 5));
      expect(weekRangeSun.end, DateTime(2026, 10, 11));

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: weekRangeWed.start,
        end: weekRangeWed.end,
        entries: const [],
        rangeType: HistoryRangeType.week,
      );
      expect(summary.dailyRecords.length, 7);
      expect(summary.dailyRecords.first.date.weekday, DateTime.monday);
      expect(summary.dailyRecords.last.date.weekday, DateTime.sunday);
    });
  });

  group('HistoryAggregator - Month Variations (28, 29, 30, 31 days)', () {
    test('non-leap February produces 28 days', () {
      final feb2023 = DateTime(2023, 2, 10);
      final range = HistoryAggregator.getMonthRange(feb2023);
      expect(range.start, DateTime(2023, 2, 1));
      expect(range.end, DateTime(2023, 2, 28));

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: range.start,
        end: range.end,
        entries: const [],
        rangeType: HistoryRangeType.month,
      );
      expect(summary.dailyRecords.length, 28);
      expect(summary.dailyRecords.first.date, DateTime(2023, 2, 1));
      expect(summary.dailyRecords.last.date, DateTime(2023, 2, 28));
    });

    test('leap year February produces 29 days', () {
      final feb2024 = DateTime(2024, 2, 20);
      final range = HistoryAggregator.getMonthRange(feb2024);
      expect(range.start, DateTime(2024, 2, 1));
      expect(range.end, DateTime(2024, 2, 29));

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: range.start,
        end: range.end,
        entries: const [],
        rangeType: HistoryRangeType.month,
      );
      expect(summary.dailyRecords.length, 29);
      expect(summary.dailyRecords.first.date, DateTime(2024, 2, 1));
      expect(summary.dailyRecords.last.date, DateTime(2024, 2, 29));
    });

    test('30-day month (April) produces 30 days', () {
      final apr2026 = DateTime(2026, 4, 15);
      final range = HistoryAggregator.getMonthRange(apr2026);
      expect(range.start, DateTime(2026, 4, 1));
      expect(range.end, DateTime(2026, 4, 30));

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: range.start,
        end: range.end,
        entries: const [],
        rangeType: HistoryRangeType.month,
      );
      expect(summary.dailyRecords.length, 30);
      expect(summary.dailyRecords.first.date, DateTime(2026, 4, 1));
      expect(summary.dailyRecords.last.date, DateTime(2026, 4, 30));
    });

    test('31-day month (October) produces 31 days', () {
      final oct2026 = DateTime(2026, 10, 7);
      final range = HistoryAggregator.getMonthRange(oct2026);
      expect(range.start, DateTime(2026, 10, 1));
      expect(range.end, DateTime(2026, 10, 31));

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: range.start,
        end: range.end,
        entries: const [],
        rangeType: HistoryRangeType.month,
      );
      expect(summary.dailyRecords.length, 31);
      expect(summary.dailyRecords.first.date, DateTime(2026, 10, 1));
      expect(summary.dailyRecords.last.date, DateTime(2026, 10, 31));
    });
  });

  group('HistoryAggregator - Year Rollover (Qua năm)', () {
    test('handles date ranges traversing Dec 31 to Jan 1 correctly', () {
      final start = DateTime(2025, 12, 28);
      final end = DateTime(2026, 1, 4);

      final entries = [
        ActivityEntry(
          id: 'y1',
          activityType: sampleActivity,
          durationMinutes: 45,
          caloriesBurned: 300.0,
          weightKgSnapshot: 68.0,
          performedAt: DateTime(2025, 12, 31, 22, 0),
        ),
        ActivityEntry(
          id: 'y2',
          activityType: sampleActivity,
          durationMinutes: 30,
          caloriesBurned: 200.0,
          weightKgSnapshot: 68.0,
          performedAt: DateTime(2026, 1, 1, 8, 30),
        ),
      ];

      final summary = HistoryAggregator.aggregate(
        bmr: bmr,
        start: start,
        end: end,
        entries: entries,
      );

      // Dec 28, 29, 30, 31, Jan 1, 2, 3, 4 = 8 days
      expect(summary.dailyRecords.length, 8);
      expect(summary.dailyRecords[0].date, DateTime(2025, 12, 28));
      expect(summary.dailyRecords[3].date, DateTime(2025, 12, 31));
      expect(summary.dailyRecords[3].activityKcal, 300.0);

      expect(summary.dailyRecords[4].date, DateTime(2026, 1, 1));
      expect(summary.dailyRecords[4].activityKcal, 200.0);
      expect(summary.dailyRecords[7].date, DateTime(2026, 1, 4));
    });
  });

  group('HistoryAggregator - Standalone Statistical Helpers', () {
    final summaries = [
      const DailySummary(bmr: 1500, activityKcal: 200, totalKcal: 1700),
      const DailySummary(bmr: 1500, activityKcal: 700, totalKcal: 2200),
      const DailySummary(bmr: 1500, activityKcal: 0, totalKcal: 1500),
    ];

    test('calculateTotal sums all total calories correctly', () {
      expect(HistoryAggregator.calculateTotal(summaries), 5400.0);
      expect(HistoryAggregator.calculateTotal(const []), 0.0);
    });

    test('calculateAverage calculates daily average accurately', () {
      expect(HistoryAggregator.calculateAverage(summaries), 1800.0);
      expect(HistoryAggregator.calculateAverage(const []), 0.0);
    });

    test('findHighest identifies summary with maximum burn', () {
      final highest = HistoryAggregator.findHighest(summaries);
      expect(highest?.totalKcal, 2200.0);
      expect(highest?.activityKcal, 700.0);
      expect(HistoryAggregator.findHighest(const []), isNull);
    });

    test('findLowest identifies summary with minimum burn', () {
      final lowest = HistoryAggregator.findLowest(summaries);
      expect(lowest?.totalKcal, 1500.0);
      expect(lowest?.activityKcal, 0.0);
      expect(HistoryAggregator.findLowest(const []), isNull);
    });
  });
}
