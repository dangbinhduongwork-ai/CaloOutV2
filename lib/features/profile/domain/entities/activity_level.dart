/// Daily physical activity level and associated TDEE multiplier.
enum ActivityLevel {
  sedentary(1.2),
  light(1.375),
  moderate(1.55),
  active(1.725),
  veryActive(1.9);

  const ActivityLevel(this.multiplier);

  final double multiplier;
}
