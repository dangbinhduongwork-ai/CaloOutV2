/// Immutable entity representing a raw or processed energy burn sample from Health platforms (Apple Health / Health Connect).
class HealthBurnSample {
  const HealthBurnSample({
    required this.id,
    required this.dateFrom,
    required this.dateTo,
    required this.caloriesBurned,
    this.steps = 0,
    this.sourceName = 'Health',
  });

  final String id;
  final DateTime dateFrom;
  final DateTime dateTo;
  final double caloriesBurned;
  final int steps;
  final String sourceName;

  /// Effective end time guaranteeing sampleEnd > dateFrom.
  DateTime get effectiveDateTo {
    if (dateTo.isAfter(dateFrom)) {
      return dateTo;
    }
    return dateFrom.add(const Duration(seconds: 1));
  }

  HealthBurnSample copyWith({
    String? id,
    DateTime? dateFrom,
    DateTime? dateTo,
    double? caloriesBurned,
    int? steps,
    String? sourceName,
  }) {
    return HealthBurnSample(
      id: id ?? this.id,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      steps: steps ?? this.steps,
      sourceName: sourceName ?? this.sourceName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthBurnSample &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dateFrom == other.dateFrom &&
          dateTo == other.dateTo &&
          caloriesBurned == other.caloriesBurned &&
          steps == other.steps &&
          sourceName == other.sourceName;

  @override
  int get hashCode => Object.hash(
        id,
        dateFrom,
        dateTo,
        caloriesBurned,
        steps,
        sourceName,
      );

  @override
  String toString() =>
      'HealthBurnSample(id: $id, from: $dateFrom, to: $dateTo, kcal: $caloriesBurned, steps: $steps, source: $sourceName)';
}
