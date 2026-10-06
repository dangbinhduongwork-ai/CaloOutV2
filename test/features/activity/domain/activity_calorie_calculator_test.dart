import 'package:caloout/features/activity/domain/services/activity_calorie_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityCalorieCalculator', () {
    test('calculates running (MET 8.0, 70 kg, 30 minutes) -> 280 kcal', () {
      // 8.0 × 70 × (30 / 60) = 560 × 0.5 = 280
      final calories = ActivityCalorieCalculator.calculate(
        met: 8.0,
        weightKg: 70.0,
        durationMinutes: 30,
      );
      expect(calories, closeTo(280.0, 0.001));
    });

    test('calculates walking (MET 3.5, 60 kg, 60 minutes) -> 210 kcal', () {
      // 3.5 × 60 × (60 / 60) = 210 × 1.0 = 210
      final calories = ActivityCalorieCalculator.calculate(
        met: 3.5,
        weightKg: 60.0,
        durationMinutes: 60,
      );
      expect(calories, closeTo(210.0, 0.001));
    });

    test('returns 0.0 for 0 minute duration', () {
      final calories = ActivityCalorieCalculator.calculate(
        met: 8.0,
        weightKg: 70.0,
        durationMinutes: 0,
      );
      expect(calories, equals(0.0));
    });

    test('handles negative duration, zero weight, negative MET safely without crash', () {
      expect(
        ActivityCalorieCalculator.calculate(
          met: 8.0,
          weightKg: 70.0,
          durationMinutes: -15,
        ),
        equals(0.0),
      );

      expect(
        ActivityCalorieCalculator.calculate(
          met: 8.0,
          weightKg: 0.0,
          durationMinutes: 30,
        ),
        equals(0.0),
      );

      expect(
        ActivityCalorieCalculator.calculate(
          met: 8.0,
          weightKg: -70.0,
          durationMinutes: 30,
        ),
        equals(0.0),
      );

      expect(
        ActivityCalorieCalculator.calculate(
          met: -2.0,
          weightKg: 70.0,
          durationMinutes: 30,
        ),
        equals(0.0),
      );
    });
  });
}
