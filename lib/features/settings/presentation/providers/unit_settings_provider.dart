import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:caloout/features/settings/domain/entities/unit_settings.dart';
import 'package:caloout/features/settings/domain/repositories/settings_repository.dart';

/// Provider for SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs);
});

/// StateNotifier for user unit preferences
class UnitSettingsNotifier extends StateNotifier<UnitSettings> {
  UnitSettingsNotifier(this._repository) : super(const UnitSettings()) {
    _loadSettings();
  }

  final SettingsRepository _repository;

  Future<void> _loadSettings() async {
    final settings = await _repository.getUnitSettings();
    state = settings;
  }

  Future<void> setWeightUnit(WeightUnit unit) async {
    final updated = state.copyWith(weightUnit: unit);
    state = updated;
    await _repository.saveUnitSettings(updated);
  }

  Future<void> setHeightUnit(HeightUnit unit) async {
    final updated = state.copyWith(heightUnit: unit);
    state = updated;
    await _repository.saveUnitSettings(updated);
  }

  Future<void> updateSettings(UnitSettings settings) async {
    state = settings;
    await _repository.saveUnitSettings(settings);
  }
}

/// Provider for UnitSettings state
final unitSettingsProvider =
    StateNotifierProvider<UnitSettingsNotifier, UnitSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return UnitSettingsNotifier(repo);
});
