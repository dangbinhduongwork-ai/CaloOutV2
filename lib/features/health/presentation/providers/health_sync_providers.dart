import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../activity/presentation/providers/activity_providers.dart';
import '../../data/repositories/health_sync_repository_impl.dart';
import '../../domain/entities/health_sync_result.dart';
import '../../domain/entities/health_sync_status.dart';
import '../../domain/repositories/health_sync_repository.dart';
import '../../domain/services/health_data_deduplicator.dart';

/// Provider for [HealthSyncRepository].
final healthSyncRepositoryProvider = Provider<HealthSyncRepository>((ref) {
  return HealthSyncRepositoryImpl();
});

/// StateNotifier for health sync toggle (persisted in SharedPreferences).
class HealthSyncEnabledNotifier extends StateNotifier<bool> {
  HealthSyncEnabledNotifier(this._prefs, this._repo, this._ref)
      : super(_prefs.getBool(_prefKey) ?? false);

  static const _prefKey = 'health_sync_enabled';
  final SharedPreferences _prefs;
  final HealthSyncRepository _repo;
  final Ref _ref;

  /// Toggles sync. If enabling, validates device availability and requests permissions.
  Future<({bool success, HealthSyncStatus status})> toggleEnabled(bool target) async {
    if (!target) {
      await _prefs.setBool(_prefKey, false);
      state = false;
      _ref.read(healthSyncStatusProvider.notifier).state = HealthSyncStatus.disabled;
      _ref.read(healthSyncResultProvider.notifier).onDisabled();
      return (success: true, status: HealthSyncStatus.disabled);
    }

    // 1. Check availability
    final availability = await _repo.checkAvailability();
    if (availability == HealthAvailabilityStatus.notInstalled ||
        availability == HealthAvailabilityStatus.notSupported) {
      _ref.read(healthSyncStatusProvider.notifier).state = HealthSyncStatus.notSupported;
      return (success: false, status: HealthSyncStatus.notSupported);
    }

    // 2. Request authorization
    _ref.read(healthSyncStatusProvider.notifier).state = HealthSyncStatus.syncing;
    final authorized = await _repo.requestReadAuthorization();
    if (!authorized) {
      _ref.read(healthSyncStatusProvider.notifier).state = HealthSyncStatus.permissionDenied;
      return (success: false, status: HealthSyncStatus.permissionDenied);
    }

    // 3. Save enabled = true
    await _prefs.setBool(_prefKey, true);
    state = true;
    _ref.read(healthSyncStatusProvider.notifier).state = HealthSyncStatus.authorized;

    // Trigger sync
    await _ref.read(healthSyncResultProvider.notifier).sync();
    return (success: true, status: HealthSyncStatus.authorized);
  }
}

/// Provider for user's health sync toggle preference. Default: false (OFF).
final healthSyncEnabledProvider =
    StateNotifierProvider<HealthSyncEnabledNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repo = ref.watch(healthSyncRepositoryProvider);
  return HealthSyncEnabledNotifier(prefs, repo, ref);
});

/// Current sync status provider.
final healthSyncStatusProvider = StateProvider<HealthSyncStatus>((ref) {
  final enabled = ref.watch(healthSyncEnabledProvider);
  return enabled ? HealthSyncStatus.authorized : HealthSyncStatus.disabled;
});

/// Notifier managing synchronization and deduplication of health data.
class HealthSyncResultNotifier extends StateNotifier<HealthSyncResult> {
  HealthSyncResultNotifier({
    required HealthSyncRepository repository,
    required Ref ref,
  })  : _repo = repository,
        _ref = ref,
        super(HealthSyncResult.disabled) {
    if (_ref.read(healthSyncEnabledProvider)) {
      sync();
    }
  }

  final HealthSyncRepository _repo;
  final Ref _ref;

  void onDisabled() {
    state = HealthSyncResult.disabled;
  }

  Future<void> sync() async {
    final isEnabled = _ref.read(healthSyncEnabledProvider);
    if (!isEnabled) {
      state = HealthSyncResult.disabled;
      return;
    }

    // Check if permission was revoked in OS settings
    final hasPerms = await _repo.hasPermissions();
    if (!hasPerms) {
      _ref.read(healthSyncStatusProvider.notifier).state =
          HealthSyncStatus.permissionRevoked;
      state = HealthSyncResult(
        status: HealthSyncStatus.permissionRevoked,
        platformSourceName: _repo.platformSourceName,
      );
      return;
    }

    try {
      final date = _ref.read(todayDateProvider);
      final start = DateTime(date.year, date.month, date.day);
      final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

      final rawSamples = await _repo.getSamples(startTime: start, endTime: end);
      final totalSteps = await _repo.getTotalSteps(startTime: start, endTime: end);

      final manualEntries =
          _ref.read(todayEntriesStreamProvider).valueOrNull ?? [];

      // Run deduplication
      final dedup = HealthDataDeduplicator.deduplicate(
        samples: rawSamples,
        manualEntries: manualEntries,
      );

      final status = rawSamples.isEmpty && (totalSteps == null || totalSteps == 0)
          ? HealthSyncStatus.noData
          : HealthSyncStatus.authorized;

      _ref.read(healthSyncStatusProvider.notifier).state = status;

      state = HealthSyncResult(
        status: status,
        deduplicatedCalories: dedup.deduplicatedCalories,
        totalSteps: totalSteps ?? 0,
        acceptedSamples: dedup.acceptedSamples,
        overlappingSamples: dedup.overlappingSamples,
        overlappingCaloriesIgnored: dedup.overlappingCaloriesIgnored,
        platformSourceName: _repo.platformSourceName,
        lastSyncedAt: DateTime.now(),
      );
    } catch (e) {
      _ref.read(healthSyncStatusProvider.notifier).state =
          HealthSyncStatus.readError;
      state = HealthSyncResult(
        status: HealthSyncStatus.readError,
        errorMessage: e.toString(),
        platformSourceName: _repo.platformSourceName,
      );
    }
  }
}

/// Result of today's health sync, including deduplicated calories and step count.
final healthSyncResultProvider =
    StateNotifierProvider<HealthSyncResultNotifier, HealthSyncResult>((ref) {
  final repo = ref.watch(healthSyncRepositoryProvider);
  final notifier = HealthSyncResultNotifier(repository: repo, ref: ref);

  // When manual entries change, automatically re-sync / re-deduplicate
  ref.listen(todayEntriesStreamProvider, (_, __) {
    if (ref.read(healthSyncEnabledProvider)) {
      notifier.sync();
    }
  });

  return notifier;
});
