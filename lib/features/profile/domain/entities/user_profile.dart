import 'activity_level.dart';
import 'gender.dart';

/// Immutable user profile entity for BMR and TDEE evaluation.
class UserProfile {
  const UserProfile({
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    this.dailyGoalKcal,
  });

  final Gender gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final ActivityLevel activityLevel;
  final double? dailyGoalKcal;

  UserProfile copyWith({
    Gender? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    double? dailyGoalKcal,
  }) {
    return UserProfile(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyGoalKcal: dailyGoalKcal ?? this.dailyGoalKcal,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          gender == other.gender &&
          age == other.age &&
          heightCm == other.heightCm &&
          weightKg == other.weightKg &&
          activityLevel == other.activityLevel &&
          dailyGoalKcal == other.dailyGoalKcal;

  @override
  int get hashCode => Object.hash(
        gender,
        age,
        heightCm,
        weightKg,
        activityLevel,
        dailyGoalKcal,
      );

  @override
  String toString() {
    return 'UserProfile(gender: $gender, age: $age, heightCm: $heightCm, '
        'weightKg: $weightKg, activityLevel: $activityLevel, dailyGoalKcal: $dailyGoalKcal)';
  }
}
