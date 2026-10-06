import '../entities/unit_settings.dart';

/// Repository interface for user unit settings (weight & height units).
abstract interface class SettingsRepository {
  /// Retrieves currently saved unit settings or defaults to metric.
  Future<UnitSettings> getUnitSettings();

  /// Saves unit settings to local storage.
  Future<void> saveUnitSettings(UnitSettings settings);
}
