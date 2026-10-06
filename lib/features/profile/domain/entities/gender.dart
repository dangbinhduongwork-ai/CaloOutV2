/// Biological gender for BMR Mifflin-St Jeor calculation.
enum Gender {
  male,
  female;

  bool get isMale => this == Gender.male;
  bool get isFemale => this == Gender.female;
}
