import 'package:caloout/core/utils/calorie_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalorieFormatter', () {
    test('formats calories with 0 decimal places rounding appropriately', () {
      expect(CalorieFormatter.format(1648.75), equals('1,649'));
      expect(CalorieFormatter.format(2555.56), equals('2,556'));
      expect(CalorieFormatter.format(210.0), equals('210'));
    });

    test('formats calories with specified decimal places', () {
      expect(CalorieFormatter.format(1648.75, decimalPlaces: 1), equals('1,648.8'));
      expect(CalorieFormatter.format(1648.75, decimalPlaces: 2), equals('1,648.75'));
    });

    test('formatWithUnit appends unit correctly', () {
      expect(CalorieFormatter.formatWithUnit(280.0), equals('280 kcal'));
      expect(
        CalorieFormatter.formatWithUnit(2555.56, decimalPlaces: 1),
        equals('2,555.6 kcal'),
      );
    });
  });
}
