import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_formatter.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../data/database/app_database.dart';
import '../data/repositories/activity_catalog_repository_impl.dart';
import '../data/repositories/activity_log_repository_impl.dart';
import '../domain/entities/activity_entry.dart';
import '../domain/entities/activity_type.dart';
import '../domain/entities/daily_summary.dart';
import '../domain/repositories/activity_catalog_repository.dart';
import '../domain/repositories/activity_log_repository.dart';
import '../domain/services/daily_summary_calculator.dart';
import '../../health/domain/entities/health_sync_status.dart';
import '../../health/presentation/providers/health_sync_providers.dart';

/// Provider for single instance of Drift AppDatabase
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Provider for ActivityCatalogRepository
final activityCatalogRepositoryProvider =
    Provider<ActivityCatalogRepository>((ref) {
  return ActivityCatalogRepositoryImpl();
});

/// Provider for ActivityLogRepository
final activityLogRepositoryProvider = Provider<ActivityLogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final catalogRepo = ref.watch(activityCatalogRepositoryProvider);
  return ActivityLogRepositoryImpl(db, catalogRepository: catalogRepo);
});

/// Provider for catalog standard activities from asset
final activityCatalogProvider =
    FutureProvider<List<ActivityType>>((ref) async {
  final repo = ref.watch(activityCatalogRepositoryProvider);
  return repo.getCatalogActivities();
});

/// StateNotifier for custom activities to refresh automatically on adding
class CustomActivitiesNotifier extends StateNotifier<AsyncValue<List<ActivityType>>> {
  CustomActivitiesNotifier(this._repo) : super(const AsyncValue.loading()) {
    refresh();
  }

  final ActivityLogRepository _repo;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getCustomActivities());
  }

  Future<ActivityType> addCustom(String name, double met) async {
    final created = await _repo.saveCustomActivity(name, met);
    await refresh();
    return created;
  }
}

final customActivitiesNotifierProvider = StateNotifierProvider<
    CustomActivitiesNotifier, AsyncValue<List<ActivityType>>>((ref) {
  final repo = ref.watch(activityLogRepositoryProvider);
  return CustomActivitiesNotifier(repo);
});

/// Provider for current calendar day date normalized to 00:00:00
/// Automatically updates if app remains open across midnight (0h).
class TodayDateNotifier extends StateNotifier<DateTime> {
  TodayDateNotifier() : super(_nowDate()) {
    // Check every minute if midnight has passed
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = _nowDate();
      if (!DateFormatter.isSameDay(now, state)) {
        state = now;
      }
    });
  }

  Timer? _timer;

  static DateTime _nowDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final todayDateProvider =
    StateNotifierProvider<TodayDateNotifier, DateTime>((ref) {
  return TodayDateNotifier();
});

/// Reactive stream provider for today's logged activities
final todayEntriesStreamProvider =
    StreamProvider<List<ActivityEntry>>((ref) {
  final repo = ref.watch(activityLogRepositoryProvider);
  final today = ref.watch(todayDateProvider);
  return repo.watchDay(today);
});

/// Computed provider combining user BMR, today's activity stream, and deduplicated Health data into DailySummary
final todaySummaryProvider = Provider<DailySummary>((ref) {
  final bmr = ref.watch(currentBmrProvider) ?? 0.0;
  final entries = ref.watch(todayEntriesStreamProvider).valueOrNull ?? [];
  final healthResult = ref.watch(healthSyncResultProvider);

  final healthActiveKcal = (healthResult.status == HealthSyncStatus.authorized ||
          healthResult.status == HealthSyncStatus.noData)
      ? healthResult.deduplicatedCalories
      : 0.0;
  final healthSteps = (healthResult.status == HealthSyncStatus.authorized ||
          healthResult.status == HealthSyncStatus.noData)
      ? healthResult.totalSteps
      : 0;

  return DailySummaryCalculator.calculate(
    bmr: bmr,
    entries: entries,
    healthActiveKcal: healthActiveKcal,
    healthSteps: healthSteps,
  );
});
