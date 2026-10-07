import 'package:drift/drift.dart';
import '../../domain/entities/activity_entry.dart';
import '../../domain/entities/activity_type.dart';
import '../../domain/repositories/activity_catalog_repository.dart';
import '../../domain/repositories/activity_log_repository.dart';
import '../database/app_database.dart';

/// Implementation of ActivityLogRepository backed by Drift SQLite database.
class ActivityLogRepositoryImpl implements ActivityLogRepository {
  ActivityLogRepositoryImpl(this._db, {this.catalogRepository});

  final AppDatabase _db;
  final ActivityCatalogRepository? catalogRepository;

  @override
  Future<void> addEntry(ActivityEntry entry) async {
    final met = entry.activityType?.met ?? 3.5;

    await _db.into(_db.activityLogs).insert(
          ActivityLogsCompanion.insert(
            id: entry.id,
            activityId: entry.activityType?.id == null
                ? const Value.absent()
                : Value(entry.activityType!.id),
            customName: entry.customName == null
                ? const Value.absent()
                : Value(entry.customName),
            met: met,
            durationMinutes: entry.durationMinutes,
            caloriesBurned: entry.caloriesBurned,
            weightKgSnapshot: entry.weightKgSnapshot,
            performedAt: entry.performedAt,
          ),
        );
  }

  @override
  Future<void> updateEntry(ActivityEntry entry) async {
    final met = entry.activityType?.met ?? 3.5;

    await (_db.update(_db.activityLogs)..where((t) => t.id.equals(entry.id)))
        .write(
      ActivityLogsCompanion(
        activityId: Value(entry.activityType?.id),
        customName: Value(entry.customName),
        met: Value(met),
        durationMinutes: Value(entry.durationMinutes),
        caloriesBurned: Value(entry.caloriesBurned),
        weightKgSnapshot: Value(entry.weightKgSnapshot),
        performedAt: Value(entry.performedAt),
      ),
    );
  }

  @override
  Future<void> deleteEntry(String id) async {
    await (_db.delete(_db.activityLogs)..where((t) => t.id.equals(id))).go();
  }

  @override
  Stream<List<ActivityEntry>> watchEntriesInRange(
      DateTime start, DateTime end) {
    final queryEnd = end.hour == 0 && end.minute == 0 && end.second == 0 && end.millisecond == 0
        ? DateTime(end.year, end.month, end.day, 23, 59, 59, 999)
        : end;

    final query = _db.select(_db.activityLogs)
      ..where((tbl) =>
          tbl.performedAt.isBiggerOrEqualValue(start) &
          tbl.performedAt.isSmallerOrEqualValue(queryEnd))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.performedAt)]);

    return query.watch().asyncMap((rows) => _mapRowsToEntries(rows));
  }

  @override
  Future<List<ActivityEntry>> getEntriesInRange(
      DateTime start, DateTime end) async {
    final queryEnd = end.hour == 0 && end.minute == 0 && end.second == 0 && end.millisecond == 0
        ? DateTime(end.year, end.month, end.day, 23, 59, 59, 999)
        : end;

    final query = _db.select(_db.activityLogs)
      ..where((tbl) =>
          tbl.performedAt.isBiggerOrEqualValue(start) &
          tbl.performedAt.isSmallerOrEqualValue(queryEnd))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.performedAt)]);

    final rows = await query.get();
    return _mapRowsToEntries(rows);
  }

  @override
  Stream<List<ActivityEntry>> watchDay(DateTime date) {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
    return watchEntriesInRange(start, end);
  }

  @override
  Future<List<ActivityEntry>> getEntriesForDay(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final query = _db.select(_db.activityLogs)
      ..where((tbl) =>
          tbl.performedAt.isBiggerOrEqualValue(start) &
          tbl.performedAt.isSmallerOrEqualValue(end))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.performedAt)]);

    final rows = await query.get();
    return _mapRowsToEntries(rows);
  }

  @override
  Future<ActivityType> saveCustomActivity(String name, double met) async {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    await _db.into(_db.customActivities).insert(
          CustomActivitiesCompanion.insert(
            id: id,
            name: name.trim(),
            met: met,
            createdAt: now,
          ),
        );

    return ActivityType(
      id: id,
      nameKey: name.trim(),
      met: met,
      category: 'custom',
      isCustom: true,
    );
  }

  @override
  Future<List<ActivityType>> getCustomActivities() async {
    final rows = await (_db.select(_db.customActivities)
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();

    return rows
        .map((r) => ActivityType(
              id: r.id,
              nameKey: r.name,
              met: r.met,
              category: 'custom',
              isCustom: true,
            ))
        .toList();
  }

  @override
  Future<void> deleteCustomActivity(String id) async {
    await (_db.delete(_db.customActivities)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearAllLogs() async {
    await _db.delete(_db.activityLogs).go();
    await _db.delete(_db.customActivities).go();
  }

  Future<List<ActivityEntry>> _mapRowsToEntries(List<ActivityLog> rows) async {
    Map<String, ActivityType>? catalogMap;
    if (catalogRepository != null) {
      try {
        final catalog = await catalogRepository!.getCatalogActivities();
        catalogMap = {for (final act in catalog) act.id: act};
      } catch (_) {
        catalogMap = null;
      }
    }

    return rows.map((r) {
      ActivityType? type;
      if (r.activityId != null && catalogMap != null) {
        type = catalogMap[r.activityId!];
      }
      type ??= ActivityType(
        id: r.activityId ?? 'custom',
        nameKey: r.customName ?? r.activityId ?? 'Activity',
        met: r.met,
        category: r.customName != null ? 'custom' : 'cardio',
        isCustom: r.customName != null,
      );

      return ActivityEntry(
        id: r.id,
        activityType: type,
        customName: r.customName,
        durationMinutes: r.durationMinutes,
        caloriesBurned: r.caloriesBurned,
        weightKgSnapshot: r.weightKgSnapshot,
        performedAt: r.performedAt,
      );
    }).toList();
  }
}
