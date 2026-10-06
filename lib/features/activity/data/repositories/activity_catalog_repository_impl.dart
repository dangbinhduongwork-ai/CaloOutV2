import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/activity_type.dart';
import '../../domain/parsers/activity_catalog_parser.dart';
import '../../domain/repositories/activity_catalog_repository.dart';

/// Implementation of ActivityCatalogRepository reading from asset file with in-memory caching.
class ActivityCatalogRepositoryImpl implements ActivityCatalogRepository {
  ActivityCatalogRepositoryImpl({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  List<ActivityType>? _cachedActivities;

  @override
  Future<List<ActivityType>> getCatalogActivities() async {
    if (_cachedActivities != null) {
      return _cachedActivities!;
    }

    final jsonString =
        await _bundle.loadString(AppConstants.metActivitiesAssetPath);
    final activities = ActivityCatalogParser.parseJson(jsonString);
    _cachedActivities = List.unmodifiable(activities);
    return _cachedActivities!;
  }
}
