import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/services/daily_summary_calculator.dart';
import 'package:caloout/features/health/domain/entities/health_burn_sample.dart';
import 'package:caloout/features/health/domain/repositories/health_sync_repository.dart';
import 'package:caloout/features/health/domain/services/health_data_deduplicator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test mock implementation of [HealthSyncRepository] simulating all platform behaviors.
class MockHealthSyncRepository implements HealthSyncRepository {
  MockHealthSyncRepository({
    this.platformName = 'Apple Health',
    this.availability = HealthAvailabilityStatus.available,
    this.authorizationGranted = true,
    this.hasPerms = true,
    this.samples = const [],
    this.steps = 5000,
    this.shouldThrowOnGetSamples = false,
  });

  final String platformName;
  final HealthAvailabilityStatus availability;
  final bool authorizationGranted;
  final bool hasPerms;
  final List<HealthBurnSample> samples;
  final int? steps;
  final bool shouldThrowOnGetSamples;

  @override
  String get platformSourceName => platformName;

  @override
  Future<HealthAvailabilityStatus> checkAvailability() async => availability;

  @override
  Future<bool> requestReadAuthorization() async => authorizationGranted;

  @override
  Future<bool> hasPermissions() async => hasPerms;

  @override
  Future<List<HealthBurnSample>> getSamples({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (shouldThrowOnGetSamples) {
      throw Exception('Simulated native health channel read failure');
    }
    return samples;
  }

  @override
  Future<int?> getTotalSteps({
    required DateTime startTime,
    required DateTime endTime,
  }) async => steps;
}

void main() {
  group('MockHealthSyncRepository & Interface Isolation', () {
    test('Simulate device not supported / Health Connect not installed', () async {
      final repo = MockHealthSyncRepository(
        platformName: 'Health Connect',
        availability: HealthAvailabilityStatus.notInstalled,
      );

      final status = await repo.checkAvailability();
      expect(status, equals(HealthAvailabilityStatus.notInstalled));
    });

    test('Simulate permission denied by user', () async {
      final repo = MockHealthSyncRepository(
        authorizationGranted: false,
      );

      final granted = await repo.requestReadAuthorization();
      expect(granted, isFalse);
    });

    test('Simulate permission revocation in system settings', () async {
      final repo = MockHealthSyncRepository(
        hasPerms: false, // User went to Settings and revoked Health access
      );

      final hasAccess = await repo.hasPermissions();
      expect(hasAccess, isFalse);
    });

    test('Simulate system read error thrown during fetch', () async {
      final repo = MockHealthSyncRepository(
        shouldThrowOnGetSamples: true,
      );

      expect(
        () => repo.getSamples(
          startTime: DateTime(2026, 10, 7),
          endTime: DateTime(2026, 10, 7, 23, 59),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Successful sync flow: fetch -> deduplicate -> integrate into DailySummary', () async {
      final mockSamples = [
        // 06:30 - 07:00: Walking (80 kcal)
        HealthBurnSample(
          id: 's1',
          dateFrom: DateTime(2026, 10, 7, 6, 30),
          dateTo: DateTime(2026, 10, 7, 7, 0),
          caloriesBurned: 80.0,
          sourceName: 'Apple Health',
        ),
        // 08:00 - 08:30: Overlaps manual gym session (08:00 - 09:00) -> 200 kcal
        HealthBurnSample(
          id: 's2',
          dateFrom: DateTime(2026, 10, 7, 8, 0),
          dateTo: DateTime(2026, 10, 7, 8, 30),
          caloriesBurned: 200.0,
          sourceName: 'Apple Health',
        ),
        // 14:00 - 14:30: Afternoon stairs (55 kcal)
        HealthBurnSample(
          id: 's3',
          dateFrom: DateTime(2026, 10, 7, 14, 0),
          dateTo: DateTime(2026, 10, 7, 14, 30),
          caloriesBurned: 55.0,
          sourceName: 'Apple Health',
        ),
      ];

      final repo = MockHealthSyncRepository(
        platformName: 'Apple Health',
        samples: mockSamples,
        steps: 8420,
      );

      // 1. Fetch raw data from interface
      final rawSamples = await repo.getSamples(
        startTime: DateTime(2026, 10, 7),
        endTime: DateTime(2026, 10, 7, 23, 59),
      );
      final steps = await repo.getTotalSteps(
        startTime: DateTime(2026, 10, 7),
        endTime: DateTime(2026, 10, 7, 23, 59),
      );

      expect(rawSamples.length, equals(3));
      expect(steps, equals(8420));

      // 2. Manual gym entry logged in CaloOut
      final manualEntries = [
        ActivityEntry(
          id: 'gym_session',
          durationMinutes: 60,
          caloriesBurned: 350.0,
          weightKgSnapshot: 70.0,
          performedAt: DateTime(2026, 10, 7, 8, 0), // 08:00 to 09:00
        ),
      ];

      // 3. Deduplicate
      final dedup = HealthDataDeduplicator.deduplicate(
        samples: rawSamples,
        manualEntries: manualEntries,
      );

      // s1 (80) + s3 (55) = 135 kcal accepted. s2 (200 kcal) ignored because of 08:00-09:00 gym session.
      expect(dedup.deduplicatedCalories, equals(135.0));
      expect(dedup.overlappingCaloriesIgnored, equals(200.0));
      expect(dedup.acceptedSamples.length, equals(2));
      expect(dedup.overlappingSamples.length, equals(1));

      // 4. Calculate DailySummary
      const userBmr = 1600.0;
      final summary = DailySummaryCalculator.calculate(
        bmr: userBmr,
        entries: manualEntries,
        healthActiveKcal: dedup.deduplicatedCalories,
        healthSteps: steps ?? 0,
      );

      // Total = BMR (1600) + Manual Gym (350) + Health Active Non-overlapping (135) = 2085 kcal
      expect(summary.bmr, equals(1600.0));
      expect(summary.activityKcal, equals(350.0));
      expect(summary.healthActiveKcal, equals(135.0));
      expect(summary.healthSteps, equals(8420));
      expect(summary.totalKcal, equals(2085.0));
    });
  });
}
