import 'package:caloout/features/profile/domain/entities/activity_level.dart';
import 'package:caloout/features/profile/domain/entities/gender.dart';
import 'package:caloout/features/profile/domain/entities/user_profile.dart';
import 'package:caloout/features/profile/domain/services/bmr_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BmrCalculator', () {
    test('calculates BMR for male correctly (Mifflin-St Jeor formula)', () {
      // 10 × 70 + 6.25 × 175 − 5 × 30 + 5 = 700 + 1093.75 - 150 + 5 = 1648.75
      const profile = UserProfile(
        gender: Gender.male,
        age: 30,
        heightCm: 175.0,
        weightKg: 70.0,
        activityLevel: ActivityLevel.moderate,
      );

      final bmr = BmrCalculator.calculate(profile);
      expect(bmr, closeTo(1648.75, 0.001));
    });

    test('calculates BMR for female correctly (Mifflin-St Jeor formula)', () {
      // 10 × 60 + 6.25 × 165 − 5 × 25 − 161 = 600 + 1031.25 - 125 - 161 = 1345.25
      const profile = UserProfile(
        gender: Gender.female,
        age: 25,
        heightCm: 165.0,
        weightKg: 60.0,
        activityLevel: ActivityLevel.light,
      );

      final bmr = BmrCalculator.calculate(profile);
      expect(bmr, closeTo(1345.25, 0.001));
    });

    test('calculateRaw produces identical results to UserProfile calculate', () {
      final fromRaw = BmrCalculator.calculateRaw(
        gender: Gender.male,
        weightKg: 70.0,
        heightCm: 175.0,
        age: 30,
      );
      expect(fromRaw, closeTo(1648.75, 0.001));
    });

    test('returns 0.0 for non-positive or invalid inputs without crashing', () {
      expect(
        BmrCalculator.calculateRaw(
          gender: Gender.male,
          weightKg: 0,
          heightCm: 175,
          age: 30,
        ),
        equals(0.0),
      );

      expect(
        BmrCalculator.calculateRaw(
          gender: Gender.female,
          weightKg: 60,
          heightCm: -10,
          age: 25,
        ),
        equals(0.0),
      );

      expect(
        BmrCalculator.calculateRaw(
          gender: Gender.male,
          weightKg: 70,
          heightCm: 175,
          age: 0,
        ),
        equals(0.0),
      );
    });
  });
}
