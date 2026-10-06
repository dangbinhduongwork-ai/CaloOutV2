/// Immutable entity representing daily calorie burn breakdown.
/// Total calories burned = BMR + activityKcal (avoids double counting activity multiplier).
class DailySummary {
  const DailySummary({
    required this.bmr,
    required this.activityKcal,
    required this.totalKcal,
  });

  final double bmr;
  final double activityKcal;
  final double totalKcal;

  DailySummary copyWith({
    double? bmr,
    double? activityKcal,
    double? totalKcal,
  }) {
    return DailySummary(
      bmr: bmr ?? this.bmr,
      activityKcal: activityKcal ?? this.activityKcal,
      totalKcal: totalKcal ?? this.totalKcal,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySummary &&
          runtimeType == other.runtimeType &&
          bmr == other.bmr &&
          activityKcal == other.activityKcal &&
          totalKcal == other.totalKcal;

  @override
  int get hashCode => Object.hash(bmr, activityKcal, totalKcal);

  @override
  String toString() =>
      'DailySummary(bmr: $bmr, activityKcal: $activityKcal, totalKcal: $totalKcal)';
}
