import '../../domain/entities/activity_level.dart';
import '../../domain/entities/gender.dart';
import '../../domain/entities/user_profile.dart';

/// Data model for UserProfile serialization to JSON.
class UserProfileModel {
  const UserProfileModel({
    required this.gender,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    this.dailyGoalKcal,
  });

  final String gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final String activityLevel;
  final double? dailyGoalKcal;

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      gender: entity.gender.name,
      age: entity.age,
      heightCm: entity.heightCm,
      weightKg: entity.weightKg,
      activityLevel: entity.activityLevel.name,
      dailyGoalKcal: entity.dailyGoalKcal,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final genderStr = json['gender'];
    if (genderStr is! String || (genderStr != 'male' && genderStr != 'female')) {
      throw const FormatException("Invalid or missing 'gender'");
    }

    final ageVal = json['age'];
    if (ageVal is! num) {
      throw const FormatException("Invalid or missing 'age'");
    }

    final heightVal = json['heightCm'];
    if (heightVal is! num) {
      throw const FormatException("Invalid or missing 'heightCm'");
    }

    final weightVal = json['weightKg'];
    if (weightVal is! num) {
      throw const FormatException("Invalid or missing 'weightKg'");
    }

    final activityStr = json['activityLevel'];
    if (activityStr is! String) {
      throw const FormatException("Invalid or missing 'activityLevel'");
    }

    final validLevels = ActivityLevel.values.map((e) => e.name).toSet();
    if (!validLevels.contains(activityStr)) {
      throw FormatException("Unrecognized activity level: '$activityStr'");
    }

    final dailyGoalVal = json['dailyGoalKcal'];
    double? dailyGoal;
    if (dailyGoalVal is num) {
      dailyGoal = dailyGoalVal.toDouble();
    }

    return UserProfileModel(
      gender: genderStr,
      age: ageVal.toInt(),
      heightCm: heightVal.toDouble(),
      weightKg: weightVal.toDouble(),
      activityLevel: activityStr,
      dailyGoalKcal: dailyGoal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'activityLevel': activityLevel,
      'dailyGoalKcal': dailyGoalKcal,
    };
  }

  UserProfile toEntity() {
    final genderEnum = gender == 'female' ? Gender.female : Gender.male;
    final activityEnum = ActivityLevel.values.firstWhere(
      (e) => e.name == activityLevel,
      orElse: () => ActivityLevel.sedentary,
    );

    return UserProfile(
      gender: genderEnum,
      age: age,
      heightCm: heightCm,
      weightKg: weightKg,
      activityLevel: activityEnum,
      dailyGoalKcal: dailyGoalKcal,
    );
  }
}
