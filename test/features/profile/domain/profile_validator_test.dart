import 'package:caloout/features/profile/domain/entities/activity_level.dart';
import 'package:caloout/features/profile/domain/entities/gender.dart';
import 'package:caloout/features/profile/domain/entities/user_profile.dart';
import 'package:caloout/features/profile/domain/validators/profile_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileValidator', () {
    group('Age validation (10 - 100)', () {
      test('boundary values (exact at boundary, just inside, just outside)', () {
        // Just outside lower bound
        expect(ProfileValidator.validateAge(9).isValid, isFalse);
        // Exact lower bound
        expect(ProfileValidator.validateAge(10).isValid, isTrue);
        // Just inside lower bound
        expect(ProfileValidator.validateAge(11).isValid, isTrue);

        // Typical valid
        expect(ProfileValidator.validateAge(30).isValid, isTrue);

        // Just inside upper bound
        expect(ProfileValidator.validateAge(99).isValid, isTrue);
        // Exact upper bound
        expect(ProfileValidator.validateAge(100).isValid, isTrue);
        // Just outside upper bound
        expect(ProfileValidator.validateAge(101).isValid, isFalse);

        // Null value
        expect(ProfileValidator.validateAge(null).isValid, isFalse);
      });
    });

    group('Height validation (100.0 - 250.0 cm)', () {
      test('boundary values (exact at boundary, just inside, just outside)', () {
        // Just outside lower bound
        expect(ProfileValidator.validateHeight(99.9).isValid, isFalse);
        // Exact lower bound
        expect(ProfileValidator.validateHeight(100.0).isValid, isTrue);
        // Just inside lower bound
        expect(ProfileValidator.validateHeight(100.1).isValid, isTrue);

        // Typical valid
        expect(ProfileValidator.validateHeight(175.0).isValid, isTrue);

        // Just inside upper bound
        expect(ProfileValidator.validateHeight(249.9).isValid, isTrue);
        // Exact upper bound
        expect(ProfileValidator.validateHeight(250.0).isValid, isTrue);
        // Just outside upper bound
        expect(ProfileValidator.validateHeight(250.1).isValid, isFalse);

        // Null value
        expect(ProfileValidator.validateHeight(null).isValid, isFalse);
      });
    });

    group('Weight validation (30.0 - 300.0 kg)', () {
      test('boundary values (exact at boundary, just inside, just outside)', () {
        // Just outside lower bound
        expect(ProfileValidator.validateWeight(29.9).isValid, isFalse);
        // Exact lower bound
        expect(ProfileValidator.validateWeight(30.0).isValid, isTrue);
        // Just inside lower bound
        expect(ProfileValidator.validateWeight(30.1).isValid, isTrue);

        // Typical valid
        expect(ProfileValidator.validateWeight(70.0).isValid, isTrue);

        // Just inside upper bound
        expect(ProfileValidator.validateWeight(299.9).isValid, isTrue);
        // Exact upper bound
        expect(ProfileValidator.validateWeight(300.0).isValid, isTrue);
        // Just outside upper bound
        expect(ProfileValidator.validateWeight(300.1).isValid, isFalse);

        // Null value
        expect(ProfileValidator.validateWeight(null).isValid, isFalse);
      });
    });

    group('validateProfile', () {
      test('returns valid for well-formed profile', () {
        const profile = UserProfile(
          gender: Gender.female,
          age: 28,
          heightCm: 165.0,
          weightKg: 55.0,
          activityLevel: ActivityLevel.moderate,
        );
        expect(ProfileValidator.validateProfile(profile).isValid, isTrue);
      });

      test('returns invalid when any field fails', () {
        const invalidProfile = UserProfile(
          gender: Gender.male,
          age: 5, // Invalid age < 10
          heightCm: 170.0,
          weightKg: 65.0,
          activityLevel: ActivityLevel.light,
        );
        final result = ProfileValidator.validateProfile(invalidProfile);
        expect(result.isValid, isFalse);
        expect(result.fieldName, equals('age'));
      });
    });
  });
}
