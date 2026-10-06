/// Immutable entity representing a physical activity and its MET rating.
class ActivityType {
  const ActivityType({
    required this.id,
    required this.nameKey,
    required this.met,
    required this.category,
    this.isCustom = false,
  });

  final String id;
  final String nameKey;
  final double met;
  final String category;
  final bool isCustom;

  ActivityType copyWith({
    String? id,
    String? nameKey,
    double? met,
    String? category,
    bool? isCustom,
  }) {
    return ActivityType(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      met: met ?? this.met,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityType &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameKey == other.nameKey &&
          met == other.met &&
          category == other.category &&
          isCustom == other.isCustom;

  @override
  int get hashCode => Object.hash(id, nameKey, met, category, isCustom);

  @override
  String toString() =>
      'ActivityType(id: $id, nameKey: $nameKey, met: $met, category: $category, isCustom: $isCustom)';
}
