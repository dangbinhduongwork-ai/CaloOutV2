import 'package:caloout/features/activity/data/database/app_database.dart';
import 'package:caloout/features/activity/data/repositories/activity_log_repository_impl.dart';
import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ActivityLogRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = ActivityLogRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  const testType = ActivityType(
    id: 'running_slow',
    nameKey: 'running_slow',
    met: 8.3,
    category: 'cardio',
  );

  test('adds, retrieves, and updates activity entry in Drift memory DB', () async {
    final entry = ActivityEntry(
      id: 'entry_1',
      activityType: testType,
      durationMinutes: 30,
      caloriesBurned: 249.0,
      weightKgSnapshot: 60.0,
      performedAt: DateTime(2026, 10, 7, 9, 30),
    );

    // Add entry
    await repository.addEntry(entry);

    // Retrieve for day
    final list = await repository.getEntriesForDay(DateTime(2026, 10, 7));
    expect(list.length, equals(1));
    expect(list.first.id, equals('entry_1'));
    expect(list.first.caloriesBurned, closeTo(249.0, 0.01));
    expect(list.first.durationMinutes, equals(30));

    // Update entry
    final updated = entry.copyWith(
      durationMinutes: 45,
      caloriesBurned: 373.5,
    );
    await repository.updateEntry(updated);

    final updatedList = await repository.getEntriesForDay(DateTime(2026, 10, 7));
    expect(updatedList.first.durationMinutes, equals(45));
    expect(updatedList.first.caloriesBurned, closeTo(373.5, 0.01));

    // Delete entry
    await repository.deleteEntry('entry_1');
    final emptyList = await repository.getEntriesForDay(DateTime(2026, 10, 7));
    expect(emptyList, isEmpty);
  });

  test('strictly filters calendar day boundary between 23:59 and 00:00', () async {
    // Entry 1: Previous day 23:59:59
    final prevDayEntry = ActivityEntry(
      id: 'prev_day',
      activityType: testType,
      durationMinutes: 20,
      caloriesBurned: 100.0,
      weightKgSnapshot: 60.0,
      performedAt: DateTime(2026, 10, 6, 23, 59, 59),
    );

    // Entry 2: Target day exact start 00:00:00
    final targetStartEntry = ActivityEntry(
      id: 'target_start',
      activityType: testType,
      durationMinutes: 30,
      caloriesBurned: 200.0,
      weightKgSnapshot: 60.0,
      performedAt: DateTime(2026, 10, 7, 0, 0, 0),
    );

    // Entry 3: Target day midday 14:30
    final targetMidEntry = ActivityEntry(
      id: 'target_mid',
      activityType: testType,
      durationMinutes: 45,
      caloriesBurned: 300.0,
      weightKgSnapshot: 60.0,
      performedAt: DateTime(2026, 10, 7, 14, 30),
    );

    // Entry 4: Target day end 23:59:59
    final targetEndEntry = ActivityEntry(
      id: 'target_end',
      activityType: testType,
      durationMinutes: 15,
      caloriesBurned: 150.0,
      weightKgSnapshot: 60.0,
      performedAt: DateTime(2026, 10, 7, 23, 59, 59),
    );

    // Entry 5: Next day exact start 00:00:00
    final nextDayEntry = ActivityEntry(
      id: 'next_day',
      activityType: testType,
      durationMinutes: 25,
      caloriesBurned: 180.0,
      weightKgSnapshot: 60.0,
      performedAt: DateTime(2026, 10, 8, 0, 0, 0),
    );

    await repository.addEntry(prevDayEntry);
    await repository.addEntry(targetStartEntry);
    await repository.addEntry(targetMidEntry);
    await repository.addEntry(targetEndEntry);
    await repository.addEntry(nextDayEntry);

    // Query specifically for 2026-10-07
    final results = await repository.getEntriesForDay(DateTime(2026, 10, 7));

    // Must strictly contain exactly the 3 entries within 2026-10-07
    expect(results.length, equals(3));
    final ids = results.map((e) => e.id).toSet();
    expect(ids, containsAll(['target_start', 'target_mid', 'target_end']));
    expect(ids.contains('prev_day'), isFalse);
    expect(ids.contains('next_day'), isFalse);
  });

  test('saves and retrieves custom activities templates', () async {
    final custom = await repository.saveCustomActivity('Kayaking', 6.5);
    expect(custom.nameKey, equals('Kayaking'));
    expect(custom.met, equals(6.5));
    expect(custom.isCustom, isTrue);

    final allCustom = await repository.getCustomActivities();
    expect(allCustom.length, equals(1));
    expect(allCustom.first.nameKey, equals('Kayaking'));

    await repository.deleteCustomActivity(custom.id);
    final emptyCustom = await repository.getCustomActivities();
    expect(emptyCustom, isEmpty);
  });
}
