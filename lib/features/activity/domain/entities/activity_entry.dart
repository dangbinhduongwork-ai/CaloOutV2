import 'activity_type.dart';

/// Immutable entity representing a logged physical activity instance.
class ActivityEntry {
  const ActivityEntry({
    required this.id,
    this.activityType,
    this.customName,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.weightKgSnapshot,
    required this.performedAt,
  });

  final String id;
  final ActivityType? activityType;
  final String? customName;
  final int durationMinutes;
  final double caloriesBurned;
  final double weightKgSnapshot;
  final DateTime performedAt;

  /// Display title fallback for presentation layers
  String get displayName {
    if (customName != null && customName!.trim().isNotEmpty) {
      return customName!.trim();
    }
    return activityType?.nameKey ?? 'Activity';
  }

  ActivityEntry copyWith({
    String? id,
    ActivityType? activityType,
    String? customName,
    int? durationMinutes,
    double? caloriesBurned,
    double? weightKgSnapshot,
    DateTime? performedAt,
  }) {
    return ActivityEntry(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      customName: customName ?? this.customName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      weightKgSnapshot: weightKgSnapshot ?? this.weightKgSnapshot,
      performedAt: performedAt ?? this.performedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          activityType == other.activityType &&
          customName == other.customName &&
          durationMinutes == other.durationMinutes &&
          caloriesBurned == other.caloriesBurned &&
          weightKgSnapshot == other.weightKgSnapshot &&
          performedAt.isAtSameMomentAs(other.performedAt);

  @override
  int get hashCode => Object.hash(
        id,
        activityType,
        customName,
        durationMinutes,
        caloriesBurned,
        weightKgSnapshot,
        performedAt.millisecondsSinceEpoch,
      );

  @override
  String toString() {
    return 'ActivityEntry(id: $id, activityType: ${activityType?.id}, customName: $customName, '
        'durationMinutes: $durationMinutes, caloriesBurned: $caloriesBurned, '
        'weightKgSnapshot: $weightKgSnapshot, performedAt: $performedAt)';
  }
}
