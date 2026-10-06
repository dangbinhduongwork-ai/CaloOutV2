import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/unit_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Implementation of SettingsRepository using SharedPreferences.
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String keyWeightUnit = 'caloout_unit_weight';
  static const String keyHeightUnit = 'caloout_unit_height';

  @override
  Future<UnitSettings> getUnitSettings() async {
    final weightRaw = _prefs.getString(keyWeightUnit);
    final heightRaw = _prefs.getString(keyHeightUnit);

    final weightUnit = weightRaw == 'lb' ? WeightUnit.lb : WeightUnit.kg;
    final heightUnit = heightRaw == 'ftIn' ? HeightUnit.ftIn : HeightUnit.cm;

    return UnitSettings(
      weightUnit: weightUnit,
      heightUnit: heightUnit,
    );
  }

  @override
  Future<void> saveUnitSettings(UnitSettings settings) async {
    await _prefs.setString(
      keyWeightUnit,
      settings.weightUnit == WeightUnit.lb ? 'lb' : 'kg',
    );
    await _prefs.setString(
      keyHeightUnit,
      settings.heightUnit == HeightUnit.ftIn ? 'ftIn' : 'cm',
    );
  }
}
