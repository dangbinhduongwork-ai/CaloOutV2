import 'package:caloout/core/utils/unit_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitConverter', () {
    test('two-way conversion between kg and lb maintains error < 0.01', () {
      final testWeightsKg = [30.0, 55.5, 70.0, 82.3, 120.0, 250.0];

      for (final kg in testWeightsKg) {
        final lb = UnitConverter.kgToLb(kg);
        final roundTripKg = UnitConverter.lbToKg(lb);
        final diff = (roundTripKg - kg).abs();

        expect(
          diff,
          lessThan(0.01),
          reason: 'Failed for weight $kg kg (converted to $lb lb, then back to $roundTripKg kg)',
        );
      }
    });

    test('two-way conversion between cm and ft/in maintains error < 0.01', () {
      final testHeightsCm = [100.0, 155.0, 168.5, 175.0, 190.0, 240.0];

      for (final cm in testHeightsCm) {
        final pair = UnitConverter.cmToFeetAndInches(cm);
        final roundTripCm = UnitConverter.ftInToCm(pair.feet, pair.inches);
        final diff = (roundTripCm - cm).abs();

        expect(
          diff,
          lessThan(0.01),
          reason: 'Failed for height $cm cm (pair: ${pair.feet} ft ${pair.inches} in, back to $roundTripCm cm)',
        );
      }
    });

    test('inchesToCm and cmToInches two-way error < 0.01', () {
      const originalCm = 175.0;
      final inches = UnitConverter.cmToInches(originalCm);
      final backCm = UnitConverter.inchesToCm(inches);
      expect((backCm - originalCm).abs(), lessThan(0.01));
    });

    test('format strings return expected format with units', () {
      expect(UnitConverter.formatWeight(70.0), equals('70.0 kg'));
      expect(UnitConverter.formatWeight(70.0, isImperial: true), contains('lb'));

      expect(UnitConverter.formatHeight(175.0), equals('175 cm'));
      expect(UnitConverter.formatHeight(175.0, isImperial: true), contains("'"));
    });
  });
}
