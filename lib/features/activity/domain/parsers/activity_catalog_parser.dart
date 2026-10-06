import 'dart:convert';
import '../entities/activity_type.dart';

/// Pure Dart parser for activity catalog JSON string.
class ActivityCatalogParser {
  const ActivityCatalogParser._();

  /// Parses JSON string into a list of [ActivityType].
  ///
  /// Throws [FormatException] if:
  /// - JSON string is malformed or empty
  /// - Missing required fields ('id', 'nameKey' / 'id', 'category', 'met')
  /// - MET value is not a valid number
  static List<ActivityType> parseJson(String jsonString) {
    if (jsonString.trim().isEmpty) {
      throw const FormatException('JSON string cannot be empty');
    }

    final dynamic decoded;
    try {
      decoded = json.decode(jsonString);
    } catch (e) {
      throw FormatException('Invalid JSON syntax: $e');
    }

    final List<dynamic> items;
    if (decoded is Map<dynamic, dynamic>) {
      final activitiesObj = decoded['activities'];
      if (activitiesObj is! List<dynamic>) {
        throw const FormatException("Root object missing 'activities' list array");
      }
      items = activitiesObj;
    } else if (decoded is List<dynamic>) {
      items = decoded;
    } else {
      throw const FormatException('Expected JSON map or array at root');
    }

    final result = <ActivityType>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item is! Map<dynamic, dynamic>) {
        throw FormatException('Item at index $i is not a valid JSON object');
      }

      final id = item['id'];
      if (id == null || id is! String || id.trim().isEmpty) {
        throw FormatException("Item at index $i is missing required 'id'");
      }

      final nameKey = item['nameKey'] ?? item['id'];
      if (nameKey == null || nameKey is! String || nameKey.trim().isEmpty) {
        throw FormatException("Item at index $i is missing required 'nameKey'");
      }

      final category = item['category'];
      if (category == null || category is! String || category.trim().isEmpty) {
        throw FormatException("Item at index $i is missing required 'category'");
      }

      final rawMet = item['met'];
      final double met;
      if (rawMet is num) {
        met = rawMet.toDouble();
      } else if (rawMet is String) {
        final parsed = double.tryParse(rawMet);
        if (parsed != null) {
          met = parsed;
        } else {
          throw FormatException("Item at index $i has invalid MET string value: '$rawMet'");
        }
      } else {
        throw FormatException("Item at index $i has invalid MET type: '$rawMet'");
      }

      final isCustom = item['isCustom'] == true;

      result.add(
        ActivityType(
          id: id.trim(),
          nameKey: nameKey.trim(),
          category: category.trim(),
          met: met,
          isCustom: isCustom,
        ),
      );
    }

    return result;
  }
}
