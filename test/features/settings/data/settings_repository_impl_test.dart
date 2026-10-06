import 'package:caloout/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:caloout/features/settings/domain/entities/unit_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsRepositoryImpl', () {
    test('defaults to metric units (kg, cm) when nothing is stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = SettingsRepositoryImpl(prefs);

      final settings = await repo.getUnitSettings();
      expect(settings.weightUnit, equals(WeightUnit.kg));
      expect(settings.heightUnit, equals(HeightUnit.cm));
    });

    test('saves and retrieves imperial units correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = SettingsRepositoryImpl(prefs);

      const imperial = UnitSettings(
        weightUnit: WeightUnit.lb,
        heightUnit: HeightUnit.ftIn,
      );

      await repo.saveUnitSettings(imperial);

      final retrieved = await repo.getUnitSettings();
      expect(retrieved.weightUnit, equals(WeightUnit.lb));
      expect(retrieved.heightUnit, equals(HeightUnit.ftIn));
    });
  });
}
