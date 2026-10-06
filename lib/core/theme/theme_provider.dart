import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Provider for SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in ProviderScope');
});

/// StateNotifier for ThemeMode (system, light, dark).
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_loadInitialTheme(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final saved = prefs.getString(AppConstants.keyThemeMode);
    switch (saved) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(AppConstants.keyThemeMode, value);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

/// StateNotifier for App Locale (vi, en).
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._prefs) : super(_loadInitialLocale(_prefs));

  final SharedPreferences _prefs;

  static Locale _loadInitialLocale(SharedPreferences prefs) {
    final saved = prefs.getString(AppConstants.keyLocale);
    if (saved == 'en') {
      return const Locale('en');
    }
    return const Locale('vi'); // Default is Vietnamese as per requirement
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _prefs.setString(AppConstants.keyLocale, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});
