/// Units for weight measurement
enum WeightUnit {
  kg,
  lb;

  bool get isMetric => this == WeightUnit.kg;
  bool get isImperial => this == WeightUnit.lb;
}

/// Units for height measurement
enum HeightUnit {
  cm,
  ftIn;

  bool get isMetric => this == HeightUnit.cm;
  bool get isImperial => this == HeightUnit.ftIn;
}

/// Immutable unit preferences for the user
class UnitSettings {
  const UnitSettings({
    this.weightUnit = WeightUnit.kg,
    this.heightUnit = HeightUnit.cm,
  });

  final WeightUnit weightUnit;
  final HeightUnit heightUnit;

  bool get isAllMetric => weightUnit.isMetric && heightUnit.isMetric;
  bool get isAllImperial => weightUnit.isImperial && heightUnit.isImperial;

  UnitSettings copyWith({
    WeightUnit? weightUnit,
    HeightUnit? heightUnit,
  }) {
    return UnitSettings(
      weightUnit: weightUnit ?? this.weightUnit,
      heightUnit: heightUnit ?? this.heightUnit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitSettings &&
          runtimeType == other.runtimeType &&
          weightUnit == other.weightUnit &&
          heightUnit == other.heightUnit;

  @override
  int get hashCode => Object.hash(weightUnit, heightUnit);

  @override
  String toString() =>
      'UnitSettings(weightUnit: $weightUnit, heightUnit: $heightUnit)';
}
