import '../entities/activity_entry.dart';
import '../entities/activity_type.dart';

/// Repository interface for logging, querying, and managing physical activity entries.
abstract interface class ActivityLogRepository {
  /// Inserts a new activity entry.
  Future<void> addEntry(ActivityEntry entry);

  /// Updates an existing activity entry.
  Future<void> updateEntry(ActivityEntry entry);

  /// Deletes an activity entry by its unique ID.
  Future<void> deleteEntry(String id);

  /// Watches all entries performed within the given date-time range.
  Stream<List<ActivityEntry>> watchEntriesInRange(DateTime start, DateTime end);

  /// Watches all entries performed on a specific calendar day (00:00:00 to 23:59:59.999).
  Stream<List<ActivityEntry>> watchDay(DateTime date);

  /// Gets all entries performed on a specific calendar day.
  Future<List<ActivityEntry>> getEntriesForDay(DateTime date);

  /// Saves a user custom activity template for reuse.
  Future<ActivityType> saveCustomActivity(String name, double met);

  /// Retrieves all custom activity templates created by the user.
  Future<List<ActivityType>> getCustomActivities();

  /// Deletes a custom activity template.
  Future<void> deleteCustomActivity(String id);

  /// Completely deletes all activity logs (e.g. during full data reset).
  Future<void> clearAllLogs();
}
