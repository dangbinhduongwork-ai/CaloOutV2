import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/activity/domain/services/daily_summary_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailySummaryCalculator', () {
    const bmr = 1648.75;

    test('no activities logged -> summary contains only BMR', () {
      final summary = DailySummaryCalculator.calculate(
        bmr: bmr,
        entries: [],
      );

      expect(summary.bmr, closeTo(1648.75, 0.001));
      expect(summary.activityKcal, equals(0.0));
      expect(summary.totalKcal, closeTo(1648.75, 0.001));
    });

    test('multiple activities logged -> sums activity calories and adds to BMR without multiplier', () {
      const runType = ActivityType(
        id: 'run',
        nameKey: 'running',
        met: 8.0,
        category: 'cardio',
      );

      const walkType = ActivityType(
        id: 'walk',
        nameKey: 'walking',
        met: 3.5,
        category: 'cardio',
      );

      final entries = [
        ActivityEntry(
          id: '1',
          activityType: runType,
          durationMinutes: 30,
          caloriesBurned: 280.0,
          weightKgSnapshot: 70.0,
          performedAt: DateTime(2026, 10, 6, 8, 0),
        ),
        ActivityEntry(
          id: '2',
          activityType: walkType,
          durationMinutes: 60,
          caloriesBurned: 210.0,
          weightKgSnapshot: 60.0,
          performedAt: DateTime(2026, 10, 6, 17, 30),
        ),
      ];

      final summary = DailySummaryCalculator.calculate(
        bmr: bmr,
        entries: entries,
      );

      // total activity calories: 280.0 + 210.0 = 490.0
      expect(summary.activityKcal, closeTo(490.0, 0.001));
      // total daily burn: 1648.75 + 490.0 = 2138.75
      expect(summary.totalKcal, closeTo(2138.75, 0.001));
      expect(summary.bmr, closeTo(1648.75, 0.001));
    });

    test('handles negative BMR safely by clamping to 0', () {
      final summary = DailySummaryCalculator.calculate(
        bmr: -100.0,
        entries: [],
      );

      expect(summary.bmr, equals(0.0));
      expect(summary.totalKcal, equals(0.0));
    });
  });
}
