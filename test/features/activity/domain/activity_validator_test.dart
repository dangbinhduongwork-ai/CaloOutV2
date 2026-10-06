import 'package:caloout/features/activity/domain/validators/activity_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityValidator', () {
    group('Duration validation (1 - 600 minutes)', () {
      test('boundary values (exact at boundary, just inside, just outside)', () {
        // Just outside lower bound
        expect(ActivityValidator.validateDuration(0).isValid, isFalse);
        // Exact lower bound
        expect(ActivityValidator.validateDuration(1).isValid, isTrue);
        // Just inside lower bound
        expect(ActivityValidator.validateDuration(2).isValid, isTrue);

        // Typical valid duration
        expect(ActivityValidator.validateDuration(45).isValid, isTrue);

        // Just inside upper bound
        expect(ActivityValidator.validateDuration(599).isValid, isTrue);
        // Exact upper bound
        expect(ActivityValidator.validateDuration(600).isValid, isTrue);
        // Just outside upper bound
        expect(ActivityValidator.validateDuration(601).isValid, isFalse);

        // Null
        expect(ActivityValidator.validateDuration(null).isValid, isFalse);
      });
    });

    group('MET validation (1.0 - 25.0)', () {
      test('boundary values (exact at boundary, just inside, just outside)', () {
        // Just outside lower bound
        expect(ActivityValidator.validateMet(0.9).isValid, isFalse);
        // Exact lower bound
        expect(ActivityValidator.validateMet(1.0).isValid, isTrue);
        // Just inside lower bound
        expect(ActivityValidator.validateMet(1.1).isValid, isTrue);

        // Typical valid MET
        expect(ActivityValidator.validateMet(8.5).isValid, isTrue);

        // Just inside upper bound
        expect(ActivityValidator.validateMet(24.9).isValid, isTrue);
        // Exact upper bound
        expect(ActivityValidator.validateMet(25.0).isValid, isTrue);
        // Just outside upper bound
        expect(ActivityValidator.validateMet(25.1).isValid, isFalse);

        // Null
        expect(ActivityValidator.validateMet(null).isValid, isFalse);
      });
    });

    group('Custom activity name validation', () {
      test('empty or whitespace strings are invalid', () {
        expect(ActivityValidator.validateCustomName('').isValid, isFalse);
        expect(ActivityValidator.validateCustomName('   ').isValid, isFalse);
        expect(ActivityValidator.validateCustomName(null).isValid, isFalse);
      });

      test('valid name within length limit', () {
        expect(ActivityValidator.validateCustomName('Bouldering').isValid, isTrue);
      });

      test('overly long name is invalid', () {
        final longName = 'A' * 101;
        expect(ActivityValidator.validateCustomName(longName).isValid, isFalse);
      });
    });
  });
}
