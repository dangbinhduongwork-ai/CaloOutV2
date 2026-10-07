import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/features/health/domain/entities/health_burn_sample.dart';
import 'package:caloout/features/health/domain/repositories/health_sync_repository.dart';
import 'package:caloout/features/health/presentation/providers/health_sync_providers.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockHealthRepo implements HealthSyncRepository {
  @override
  String get platformSourceName => 'Health';
  @override
  Future<HealthAvailabilityStatus> checkAvailability() async => HealthAvailabilityStatus.notSupported;
  @override
  Future<bool> requestReadAuthorization() async => false;
  @override
  Future<bool> hasPermissions() async => false;
  @override
  Future<List<HealthBurnSample>> getSamples({required DateTime startTime, required DateTime endTime}) async => [];
  @override
  Future<int?> getTotalSteps({required DateTime startTime, required DateTime endTime}) async => 0;
}

void main() {
  test('todaySummaryProvider combines user BMR and activities without multiplier', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    const testBmr = 1648.75;
    final entries = [
      ActivityEntry(
        id: '1',
        activityType: const ActivityType(id: 'run', nameKey: 'Running', met: 8.0, category: 'cardio'),
        durationMinutes: 30,
        caloriesBurned: 280.0,
        weightKgSnapshot: 70.0,
        performedAt: DateTime(2026, 10, 7, 8, 0),
      ),
      ActivityEntry(
        id: '2',
        activityType: const ActivityType(id: 'walk', nameKey: 'Walking', met: 3.5, category: 'cardio'),
        durationMinutes: 60,
        caloriesBurned: 210.0,
        weightKgSnapshot: 60.0,
        performedAt: DateTime(2026, 10, 7, 18, 0),
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        healthSyncRepositoryProvider.overrideWithValue(_MockHealthRepo()),
        currentBmrProvider.overrideWithValue(testBmr),
        todayEntriesStreamProvider.overrideWith((ref) => Stream.value(entries)),
      ],
    );
    addTearDown(container.dispose);

    // Wait for the stream to emit entries
    await container.read(todayEntriesStreamProvider.future);

    final summary = container.read(todaySummaryProvider);

    // BMR portion
    expect(summary.bmr, closeTo(1648.75, 0.001));
    // Activity portion: 280.0 + 210.0 = 490.0
    expect(summary.activityKcal, closeTo(490.0, 0.001));
    // Total burn = 1648.75 + 490.0 = 2138.75
    expect(summary.totalKcal, closeTo(2138.75, 0.001));
  });
}
