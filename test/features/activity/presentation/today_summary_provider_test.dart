import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('todaySummaryProvider combines user BMR and activities without multiplier', () {
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
        currentBmrProvider.overrideWithValue(testBmr),
        todayEntriesStreamProvider.overrideWith((ref) => Stream.value(entries)),
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(todaySummaryProvider);

    // BMR portion
    expect(summary.bmr, closeTo(1648.75, 0.001));
    // Activity portion: 280.0 + 210.0 = 490.0
    expect(summary.activityKcal, closeTo(490.0, 0.001));
    // Total burn = 1648.75 + 490.0 = 2138.75
    expect(summary.totalKcal, closeTo(2138.75, 0.001));
  });
}
