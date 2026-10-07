/// Immutable entity representing daily calorie burn breakdown.
/// Total calories burned = BMR + activityKcal + healthActiveKcal (avoids double counting).
class DailySummary {
  const DailySummary({
    required this.bmr,
    required this.activityKcal,
    required this.totalKcal,
    this.healthActiveKcal = 0.0,
    this.healthSteps = 0,
  });

  final double bmr;
  final double activityKcal;
  final double healthActiveKcal;
  final int healthSteps;
  final double totalKcal;

  DailySummary copyWith({
    double? bmr,
    double? activityKcal,
    double? healthActiveKcal,
    int? healthSteps,
    double? totalKcal,
  }) {
    return DailySummary(
      bmr: bmr ?? this.bmr,
      activityKcal: activityKcal ?? this.activityKcal,
      healthActiveKcal: healthActiveKcal ?? this.healthActiveKcal,
      healthSteps: healthSteps ?? this.healthSteps,
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
          healthActiveKcal == other.healthActiveKcal &&
          healthSteps == other.healthSteps &&
          totalKcal == other.totalKcal;

  @override
  int get hashCode =>
      Object.hash(bmr, activityKcal, healthActiveKcal, healthSteps, totalKcal);

  @override
  String toString() =>
      'DailySummary(bmr: $bmr, activityKcal: $activityKcal, healthActiveKcal: $healthActiveKcal, healthSteps: $healthSteps, totalKcal: $totalKcal)';
}
