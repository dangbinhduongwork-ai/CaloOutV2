import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Table storing logged physical activities with historical snapshots.
class ActivityLogs extends Table {
  TextColumn get id => text()();
  TextColumn get activityId => text().nullable()();
  TextColumn get customName => text().nullable()();
  RealColumn get met => real()();
  IntColumn get durationMinutes => integer()();
  RealColumn get caloriesBurned => real()();
  RealColumn get weightKgSnapshot => real()();
  DateTimeColumn get performedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  List<String> get customStatements => [
        'CREATE INDEX IF NOT EXISTS activity_logs_performed_at_idx ON activity_logs (performed_at);',
      ];
}

/// Table storing user-created custom activities for reuse.
class CustomActivities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get met => real()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [ActivityLogs, CustomActivities])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'caloout_app_db');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Create custom index for performedAt
          await customStatement(
            'CREATE INDEX IF NOT EXISTS activity_logs_performed_at_idx ON activity_logs (performed_at);',
          );
        },
      );
}
