/// Core application constants including validation limits and preferences keys.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'CaloOut';
  static const String appVersion = '1.0.0';

  // Validation Limits (as per requirements)
  static const int minAge = 10;
  static const int maxAge = 100;

  static const double minHeightCm = 100.0;
  static const double maxHeightCm = 250.0;

  static const double minWeightKg = 30.0;
  static const double maxWeightKg = 300.0;

  // SharedPreferences Keys
  static const String keyProfile = 'caloout_user_profile';
  static const String keyThemeMode = 'caloout_theme_mode';
  static const String keyLocale = 'caloout_locale';
  static const String keyUnitSystem = 'caloout_unit_system';
  static const String keyDailyGoalCustom = 'caloout_daily_goal_custom';
  static const String keyUseCustomGoal = 'caloout_use_custom_goal';
  static const String keyOnboardingComplete = 'caloout_onboarding_completed';

  // Assets
  static const String metActivitiesAssetPath = 'assets/data/met_activities.json';
}
