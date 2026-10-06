import 'package:caloout/core/constants/app_constants.dart';
import 'package:caloout/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:caloout/features/profile/domain/entities/activity_level.dart';
import 'package:caloout/features/profile/domain/entities/gender.dart';
import 'package:caloout/features/profile/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProfileRepositoryImpl', () {
    test('returns null when no profile is saved', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = ProfileRepositoryImpl(prefs);

      final profile = await repo.getProfile();
      expect(profile, isNull);
    });

    test('saves and retrieves valid profile successfully', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = ProfileRepositoryImpl(prefs);

      const sampleProfile = UserProfile(
        gender: Gender.male,
        age: 30,
        heightCm: 175.0,
        weightKg: 70.0,
        activityLevel: ActivityLevel.moderate,
        dailyGoalKcal: 2500.0,
      );

      await repo.saveProfile(sampleProfile);

      final retrieved = await repo.getProfile();
      expect(retrieved, isNotNull);
      expect(retrieved!.gender, equals(Gender.male));
      expect(retrieved.age, equals(30));
      expect(retrieved.heightCm, equals(175.0));
      expect(retrieved.weightKg, equals(70.0));
      expect(retrieved.activityLevel, equals(ActivityLevel.moderate));
      expect(retrieved.dailyGoalKcal, equals(2500.0));
    });

    test('returns null gracefully when json data is corrupted syntax', () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.keyProfile: '{invalid_json_content}',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = ProfileRepositoryImpl(prefs);

      final profile = await repo.getProfile();
      expect(profile, isNull);
    });

    test('returns null gracefully when json data is missing required fields', () async {
      // Missing 'age' and 'heightCm'
      SharedPreferences.setMockInitialValues({
        AppConstants.keyProfile: '{"gender": "male", "weightKg": 70.0}',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = ProfileRepositoryImpl(prefs);

      final profile = await repo.getProfile();
      expect(profile, isNull);
    });

    test('returns null gracefully when gender has invalid enum value', () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.keyProfile:
            '{"gender": "alien", "age": 25, "heightCm": 170.0, "weightKg": 65.0, "activityLevel": "moderate"}',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = ProfileRepositoryImpl(prefs);

      final profile = await repo.getProfile();
      expect(profile, isNull);
    });

    test('clearProfile removes stored data completely', () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.keyProfile:
            '{"gender": "female", "age": 28, "heightCm": 160.0, "weightKg": 52.0, "activityLevel": "light"}',
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = ProfileRepositoryImpl(prefs);

      expect(await repo.getProfile(), isNotNull);

      await repo.clearProfile();
      expect(await repo.getProfile(), isNull);
    });
  });
}
