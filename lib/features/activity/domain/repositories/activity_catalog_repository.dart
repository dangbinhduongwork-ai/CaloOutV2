import '../entities/activity_type.dart';

/// Repository contract for retrieving standard activities catalog from data sources.
abstract interface class ActivityCatalogRepository {
  /// Fetches standard activities parsed from catalog database or asset file.
  Future<List<ActivityType>> getCatalogActivities();
}
