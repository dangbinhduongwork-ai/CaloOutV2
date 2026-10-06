import 'package:caloout/features/profile/domain/entities/activity_level.dart';
import 'package:caloout/features/profile/domain/services/tdee_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TdeeCalculator', () {
    const maleBmr = 1648.75;

    test('calculates moderate activity level TDEE correctly', () {
      // 1648.75 × 1.55 = 2555.5625
      final tdee = TdeeCalculator.calculate(maleBmr, ActivityLevel.moderate);
      expect(tdee, closeTo(2555.5625, 0.0001));
    });

    test('verifies all 5 activity levels with appropriate multipliers', () {
      // Sedentary: 1.2 -> 1978.5
      expect(
        TdeeCalculator.calculate(maleBmr, ActivityLevel.sedentary),
        closeTo(1978.5, 0.0001),
      );

      // Light: 1.375 -> 2267.03125
      expect(
        TdeeCalculator.calculate(maleBmr, ActivityLevel.light),
        closeTo(2267.03125, 0.0001),
      );

      // Moderate: 1.55 -> 2555.5625
      expect(
        TdeeCalculator.calculate(maleBmr, ActivityLevel.moderate),
        closeTo(2555.5625, 0.0001),
      );

      // Active: 1.725 -> 2844.09375
      expect(
        TdeeCalculator.calculate(maleBmr, ActivityLevel.active),
        closeTo(2844.09375, 0.0001),
      );

      // Very Active: 1.9 -> 3132.625
      expect(
        TdeeCalculator.calculate(maleBmr, ActivityLevel.veryActive),
        closeTo(3132.625, 0.0001),
      );
    });

    test('handles non-positive BMR safely', () {
      expect(TdeeCalculator.calculate(0.0, ActivityLevel.moderate), equals(0.0));
      expect(TdeeCalculator.calculate(-500.0, ActivityLevel.active), equals(0.0));
    });
  });
}
