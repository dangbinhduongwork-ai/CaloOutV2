import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/health/domain/entities/health_burn_sample.dart';
import 'package:caloout/features/health/domain/services/health_data_deduplicator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HealthDataDeduplicator', () {
    const runningType = ActivityType(
      id: 'running_general',
      nameKey: 'running',
      met: 8.0,
      category: 'cardio',
    );

    // Manual workout from 07:00 to 07:45 (45 minutes)
    final manualEntry1 = ActivityEntry(
      id: 'manual_1',
      activityType: runningType,
      durationMinutes: 45,
      caloriesBurned: 350.0,
      weightKgSnapshot: 70.0,
      performedAt: DateTime(2026, 10, 7, 7, 0),
    );

    // Manual workout from 18:00 to 19:00 (60 minutes)
    final manualEntry2 = ActivityEntry(
      id: 'manual_2',
      activityType: runningType,
      durationMinutes: 60,
      caloriesBurned: 400.0,
      weightKgSnapshot: 70.0,
      performedAt: DateTime(2026, 10, 7, 18, 0),
    );

    test('Case 1: Empty samples -> yields 0 calories and empty lists', () {
      final result = HealthDataDeduplicator.deduplicate(
        samples: [],
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(0.0));
      expect(result.overlappingCaloriesIgnored, equals(0.0));
      expect(result.acceptedSamples, isEmpty);
      expect(result.overlappingSamples, isEmpty);
    });

    test('Case 2: No manual entries -> all positive health samples accepted', () {
      final samples = [
        HealthBurnSample(
          id: 's1',
          dateFrom: DateTime(2026, 10, 7, 7, 0),
          dateTo: DateTime(2026, 10, 7, 7, 30),
          caloriesBurned: 150.0,
        ),
        HealthBurnSample(
          id: 's2',
          dateFrom: DateTime(2026, 10, 7, 10, 0),
          dateTo: DateTime(2026, 10, 7, 10, 15),
          caloriesBurned: 50.0,
        ),
      ];

      final result = HealthDataDeduplicator.deduplicate(
        samples: samples,
        manualEntries: [],
      );

      expect(result.deduplicatedCalories, equals(200.0));
      expect(result.overlappingCaloriesIgnored, equals(0.0));
      expect(result.acceptedSamples.length, equals(2));
      expect(result.overlappingSamples, isEmpty);
    });

    test('Case 3: Complete overlap -> sample fully inside manual workout window is excluded', () {
      // 07:10 to 07:35 is entirely inside 07:00 - 07:45
      final sampleInside = HealthBurnSample(
        id: 's_inside',
        dateFrom: DateTime(2026, 10, 7, 7, 10),
        dateTo: DateTime(2026, 10, 7, 7, 35),
        caloriesBurned: 180.0,
      );

      final result = HealthDataDeduplicator.deduplicate(
        samples: [sampleInside],
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(0.0));
      expect(result.overlappingCaloriesIgnored, equals(180.0));
      expect(result.acceptedSamples, isEmpty);
      expect(result.overlappingSamples.length, equals(1));
      expect(result.overlappingSamples.first.id, equals('s_inside'));
    });

    test('Case 4: Partial overlap (straddles start) -> sample starts before and ends inside manual window', () {
      // 06:45 to 07:15 overlaps 07:00 - 07:45
      final sampleStraddleStart = HealthBurnSample(
        id: 's_start_overlap',
        dateFrom: DateTime(2026, 10, 7, 6, 45),
        dateTo: DateTime(2026, 10, 7, 7, 15),
        caloriesBurned: 120.0,
      );

      final result = HealthDataDeduplicator.deduplicate(
        samples: [sampleStraddleStart],
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(0.0));
      expect(result.overlappingCaloriesIgnored, equals(120.0));
      expect(result.overlappingSamples.length, equals(1));
    });

    test('Case 5: Partial overlap (straddles end) -> sample starts inside and ends after manual window', () {
      // 07:30 to 08:00 overlaps 07:00 - 07:45
      final sampleStraddleEnd = HealthBurnSample(
        id: 's_end_overlap',
        dateFrom: DateTime(2026, 10, 7, 7, 30),
        dateTo: DateTime(2026, 10, 7, 8, 0),
        caloriesBurned: 160.0,
      );

      final result = HealthDataDeduplicator.deduplicate(
        samples: [sampleStraddleEnd],
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(0.0));
      expect(result.overlappingCaloriesIgnored, equals(160.0));
      expect(result.overlappingSamples.length, equals(1));
    });

    test('Case 6: Sample encompasses entire manual workout -> excluded', () {
      // 06:30 to 08:30 encompasses 07:00 - 07:45
      final sampleEncompassing = HealthBurnSample(
        id: 's_encompassing',
        dateFrom: DateTime(2026, 10, 7, 6, 30),
        dateTo: DateTime(2026, 10, 7, 8, 30),
        caloriesBurned: 500.0,
      );

      final result = HealthDataDeduplicator.deduplicate(
        samples: [sampleEncompassing],
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(0.0));
      expect(result.overlappingCaloriesIgnored, equals(500.0));
      expect(result.overlappingSamples.length, equals(1));
    });

    test('Case 7: Non-overlapping samples strictly before and after manual window -> kept', () {
      // Before: 06:00 to 06:50 (manual starts 07:00)
      final sampleBefore = HealthBurnSample(
        id: 's_before',
        dateFrom: DateTime(2026, 10, 7, 6, 0),
        dateTo: DateTime(2026, 10, 7, 6, 50),
        caloriesBurned: 80.0,
      );

      // Boundary touch: 07:45 to 08:15 (manual ends 07:45 exactly)
      // Since interval is [07:00, 07:45), sample at [07:45, 08:15) does not overlap
      final sampleTouchBoundary = HealthBurnSample(
        id: 's_boundary',
        dateFrom: DateTime(2026, 10, 7, 7, 45),
        dateTo: DateTime(2026, 10, 7, 8, 15),
        caloriesBurned: 95.0,
      );

      // Midday incidental: 12:00 to 12:30
      final sampleMidday = HealthBurnSample(
        id: 's_midday',
        dateFrom: DateTime(2026, 10, 7, 12, 0),
        dateTo: DateTime(2026, 10, 7, 12, 30),
        caloriesBurned: 45.0,
      );

      final result = HealthDataDeduplicator.deduplicate(
        samples: [sampleBefore, sampleTouchBoundary, sampleMidday],
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(220.0)); // 80 + 95 + 45
      expect(result.overlappingCaloriesIgnored, equals(0.0));
      expect(result.acceptedSamples.length, equals(3));
      expect(result.overlappingSamples, isEmpty);
    });

    test('Case 8: Interleaved multiple manual entries and health samples', () {
      final samples = [
        // 06:00 - 06:30: Morning walk (kept: 70 kcal)
        HealthBurnSample(
          id: 's1',
          dateFrom: DateTime(2026, 10, 7, 6, 0),
          dateTo: DateTime(2026, 10, 7, 6, 30),
          caloriesBurned: 70.0,
        ),
        // 07:15 - 07:40: Overlaps manualEntry1 (07:00 - 07:45) -> ignored: 180 kcal
        HealthBurnSample(
          id: 's2',
          dateFrom: DateTime(2026, 10, 7, 7, 15),
          dateTo: DateTime(2026, 10, 7, 7, 40),
          caloriesBurned: 180.0,
        ),
        // 11:00 - 11:30: Office stairs (kept: 40 kcal)
        HealthBurnSample(
          id: 's3',
          dateFrom: DateTime(2026, 10, 7, 11, 0),
          dateTo: DateTime(2026, 10, 7, 11, 30),
          caloriesBurned: 40.0,
        ),
        // 18:20 - 18:50: Overlaps manualEntry2 (18:00 - 19:00) -> ignored: 220 kcal
        HealthBurnSample(
          id: 's4',
          dateFrom: DateTime(2026, 10, 7, 18, 20),
          dateTo: DateTime(2026, 10, 7, 18, 50),
          caloriesBurned: 220.0,
        ),
        // 20:30 - 21:00: Evening walk (kept: 65 kcal)
        HealthBurnSample(
          id: 's5',
          dateFrom: DateTime(2026, 10, 7, 20, 30),
          dateTo: DateTime(2026, 10, 7, 21, 0),
          caloriesBurned: 65.0,
        ),
      ];

      final result = HealthDataDeduplicator.deduplicate(
        samples: samples,
        manualEntries: [manualEntry1, manualEntry2],
      );

      // Kept: s1 (70) + s3 (40) + s5 (65) = 175.0 kcal
      expect(result.deduplicatedCalories, equals(175.0));
      expect(result.acceptedSamples.map((s) => s.id), equals(['s1', 's3', 's5']));

      // Ignored: s2 (180) + s4 (220) = 400.0 kcal
      expect(result.overlappingCaloriesIgnored, equals(400.0));
      expect(result.overlappingSamples.map((s) => s.id), equals(['s2', 's4']));
    });

    test('Case 9: Zero or negative calorie samples are discarded', () {
      final samples = [
        HealthBurnSample(
          id: 'zero',
          dateFrom: DateTime(2026, 10, 7, 10, 0),
          dateTo: DateTime(2026, 10, 7, 10, 15),
          caloriesBurned: 0.0,
        ),
        HealthBurnSample(
          id: 'neg',
          dateFrom: DateTime(2026, 10, 7, 11, 0),
          dateTo: DateTime(2026, 10, 7, 11, 15),
          caloriesBurned: -15.0,
        ),
      ];

      final result = HealthDataDeduplicator.deduplicate(
        samples: samples,
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(0.0));
      expect(result.overlappingCaloriesIgnored, equals(0.0));
      expect(result.acceptedSamples, isEmpty);
      expect(result.overlappingSamples, isEmpty);
    });

    test('Case 10: Instantaneous samples (dateTo <= dateFrom) inside manual workout are caught', () {
      final instantaneousPoint = HealthBurnSample(
        id: 'instant_sample',
        dateFrom: DateTime(2026, 10, 7, 7, 20),
        dateTo: DateTime(2026, 10, 7, 7, 20), // Same timestamp
        caloriesBurned: 15.0,
      );

      final result = HealthDataDeduplicator.deduplicate(
        samples: [instantaneousPoint],
        manualEntries: [manualEntry1],
      );

      expect(result.deduplicatedCalories, equals(0.0));
      expect(result.overlappingCaloriesIgnored, equals(15.0));
      expect(result.overlappingSamples.length, equals(1));
    });
  });
}
