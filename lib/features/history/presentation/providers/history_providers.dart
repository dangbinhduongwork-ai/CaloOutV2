import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../activity/domain/entities/activity_entry.dart';
import '../../activity/domain/entities/activity_type.dart';
import '../../activity/domain/services/activity_calorie_calculator.dart';
import '../../activity/presentation/providers/activity_providers.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../domain/entities/history_period_summary.dart';
import '../domain/entities/history_range_type.dart';
import '../domain/services/history_aggregator.dart';

/// Provider for selected history view type (Day, Week, Month)
final historyRangeTypeProvider =
    StateProvider<HistoryRangeType>((ref) => HistoryRangeType.week);

/// Provider for current anchor date in history navigation
final historyAnchorDateProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

/// Computed provider for current active date range (start, end)
final historyDateRangeProvider =
    Provider<({DateTime start, DateTime end})>((ref) {
  final rangeType = ref.watch(historyRangeTypeProvider);
  final anchor = ref.watch(historyAnchorDateProvider);

  switch (rangeType) {
    case HistoryRangeType.day:
      return HistoryAggregator.getDayRange(anchor);
    case HistoryRangeType.week:
      return HistoryAggregator.getWeekRange(anchor);
    case HistoryRangeType.month:
      return HistoryAggregator.getMonthRange(anchor);
  }
});

/// Checks if user can navigate forward into future (blocked if end date >= today)
final canGoForwardProvider = Provider<bool>((ref) {
  final range = ref.watch(historyDateRangeProvider);
  final today = ref.watch(todayDateProvider);
  final normalizedEnd = DateTime(range.end.year, range.end.month, range.end.day);
  final normalizedToday = DateTime(today.year, today.month, today.day);

  return normalizedEnd.isBefore(normalizedToday);
});

/// Reactive stream provider for HistoryPeriodSummary
final historyPeriodSummaryProvider =
    StreamProvider<HistoryPeriodSummary>((ref) {
  final range = ref.watch(historyDateRangeProvider);
  final rangeType = ref.watch(historyRangeTypeProvider);
  final bmr = ref.watch(currentBmrProvider) ?? 0.0;
  final repo = ref.watch(activityLogRepositoryProvider);

  final queryStart = DateTime(range.start.year, range.start.month, range.start.day, 0, 0, 0);
  final queryEnd = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59, 999);

  return repo
      .watchEntriesInRange(queryStart, queryEnd)
      .map((entries) => HistoryAggregator.aggregate(
            bmr: bmr,
            start: range.start,
            end: range.end,
            entries: entries,
            rangeType: rangeType,
          ));
});

/// Controller helper for navigating previous and next time intervals
class HistoryNavigationController {
  const HistoryNavigationController(this.ref);

  final WidgetRef ref;

  void goToPrevious() {
    final rangeType = ref.read(historyRangeTypeProvider);
    final anchor = ref.read(historyAnchorDateProvider);

    DateTime newAnchor;
    switch (rangeType) {
      case HistoryRangeType.day:
        newAnchor = DateTime(anchor.year, anchor.month, anchor.day - 1);
        break;
      case HistoryRangeType.week:
        newAnchor = DateTime(anchor.year, anchor.month, anchor.day - 7);
        break;
      case HistoryRangeType.month:
        newAnchor = DateTime(anchor.year, anchor.month - 1, 1);
        break;
    }
    ref.read(historyAnchorDateProvider.notifier).state = newAnchor;
  }

  void goToNext() {
    if (!ref.read(canGoForwardProvider)) return;

    final rangeType = ref.read(historyRangeTypeProvider);
    final anchor = ref.read(historyAnchorDateProvider);
    final now = ref.read(todayDateProvider);

    DateTime newAnchor;
    switch (rangeType) {
      case HistoryRangeType.day:
        newAnchor = DateTime(anchor.year, anchor.month, anchor.day + 1);
        break;
      case HistoryRangeType.week:
        newAnchor = DateTime(anchor.year, anchor.month, anchor.day + 7);
        break;
      case HistoryRangeType.month:
        newAnchor = DateTime(anchor.year, anchor.month + 1, 1);
        break;
    }

    if (newAnchor.isAfter(now)) {
      newAnchor = now;
    }
    ref.read(historyAnchorDateProvider.notifier).state = newAnchor;
  }

  void setRangeType(HistoryRangeType type) {
    ref.read(historyRangeTypeProvider.notifier).state = type;
  }

  void resetToToday() {
    ref.read(historyAnchorDateProvider.notifier).state = ref.read(todayDateProvider);
  }
}

/// Seeds mock data for the last 60 days strictly in debug mode (kDebugMode)
Future<void> debugSeedSampleHistoryData(WidgetRef ref) async {
  if (!kDebugMode) return;

  final repo = ref.read(activityLogRepositoryProvider);
  final profile = ref.read(profileProvider).valueOrNull;
  final weightKg = profile?.weightKg ?? 70.0;
  final now = DateTime.now();
  final random = Random();

  final sampleActivities = [
    const ActivityType(id: 'running_slow', nameKey: 'Chạy bộ chậm (8.0 km/h)', met: 8.3, category: 'cardio'),
    const ActivityType(id: 'walking_moderate', nameKey: 'Đi bộ vừa phải (4.8 km/h)', met: 3.5, category: 'cardio'),
    const ActivityType(id: 'cycling_leisure', nameKey: 'Đạp xe thong thả (15 km/h)', met: 5.8, category: 'cardio'),
    const ActivityType(id: 'swimming_moderate', nameKey: 'Bơi lội vừa phải', met: 5.8, category: 'cardio'),
    const ActivityType(id: 'weight_training_moderate', nameKey: 'Gym / Kháng lực vừa phải', met: 3.5, category: 'strength'),
    const ActivityType(id: 'badminton', nameKey: 'Cầu lông (phong trào)', met: 5.5, category: 'sports'),
    const ActivityType(id: 'football', nameKey: 'Bóng đá', met: 7.0, category: 'sports'),
    const ActivityType(id: 'hiit', nameKey: 'HIIT / Calisthenics', met: 8.0, category: 'cardio'),
  ];

  // Seed activities across the last 60 days (approx 3-5 sessions per week)
  for (int daysAgo = 59; daysAgo >= 0; daysAgo--) {
    final dayDate = now.subtract(Duration(days: daysAgo));

    // 70% chance of exercising on any given day
    if (random.nextDouble() < 0.70) {
      final sessionCount = random.nextBool() ? 1 : 2;
      for (int s = 0; s < sessionCount; s++) {
        final act = sampleActivities[random.nextInt(sampleActivities.length)];
        final duration = (random.nextInt(4) + 2) * 15; // 30, 45, 60, 75 mins
        final calories = ActivityCalorieCalculator.calculate(
          met: act.met,
          weightKg: weightKg,
          durationMinutes: duration,
        );

        final entry = ActivityEntry(
          id: const Uuid().v4(),
          activityType: act,
          durationMinutes: duration,
          caloriesBurned: calories,
          weightKgSnapshot: weightKg,
          performedAt: DateTime(
            dayDate.year,
            dayDate.month,
            dayDate.day,
            s == 0 ? 7 + random.nextInt(3) : 17 + random.nextInt(3),
            random.nextInt(60),
          ),
        );

        await repo.addEntry(entry);
      }
    }
  }
}
