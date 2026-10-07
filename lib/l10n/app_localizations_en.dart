// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CaloOut';

  @override
  String get tagline => 'Daily Calorie Burn Tracker';

  @override
  String get navDashboard => 'Today';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String get disclaimer =>
      'Results are estimates only and do not replace professional medical advice.';

  @override
  String get onboardingTitle => 'Welcome to CaloOut';

  @override
  String get onboardingSubtitle =>
      'Set up your profile to calculate accurate BMR and TDEE metrics';

  @override
  String get onboardingStep1Title => 'Basic Information';

  @override
  String get onboardingStep1Subtitle => 'Select your biological gender and age';

  @override
  String get onboardingStep2Title => 'Height & Weight';

  @override
  String get onboardingStep2Subtitle => 'Enter your physical body measurements';

  @override
  String get onboardingStep3Title => 'Activity Level';

  @override
  String get onboardingStep3Subtitle =>
      'Your daily physical habits and exercise routine';

  @override
  String get onboardingResultTitle => 'Your Metrics';

  @override
  String get onboardingResultSubtitle =>
      'Caloric burn calculated specifically for your body';

  @override
  String get nextStep => 'Next';

  @override
  String get previousStep => 'Back';

  @override
  String get finishOnboarding => 'Finish & Start';

  @override
  String get getStarted => 'Get Started';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get undo => 'Undo';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get age => 'Age';

  @override
  String get ageUnit => 'years old';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get dailyActivityLevel => 'Activity Level';

  @override
  String get activitySedentary => 'Sedentary (1.2)';

  @override
  String get activitySedentaryDesc => 'Desk job, little to no exercise';

  @override
  String get activityLight => 'Light (1.375)';

  @override
  String get activityLightDesc => 'Light exercise 1–3 days/week';

  @override
  String get activityModerate => 'Moderate (1.55)';

  @override
  String get activityModerateDesc => 'Moderate exercise 3–5 days/week';

  @override
  String get activityActive => 'Active (1.725)';

  @override
  String get activityActiveDesc => 'Hard exercise 6–7 days/week';

  @override
  String get activityVeryActive => 'Very Active (1.9)';

  @override
  String get activityVeryActiveDesc => 'Athlete or heavy physical labor job';

  @override
  String get unitMetric => 'Metric (kg, cm)';

  @override
  String get unitImperial => 'Imperial (lb, ft-in)';

  @override
  String get unitKg => 'kg';

  @override
  String get unitLb => 'lb';

  @override
  String get unitCm => 'cm';

  @override
  String get unitFt => 'ft';

  @override
  String get unitIn => 'in';

  @override
  String get unitMinutes => 'min';

  @override
  String get unitHours => 'hr';

  @override
  String get unitKcal => 'kcal';

  @override
  String get validationAge => 'Age must be between 10 and 100';

  @override
  String get validationHeight => 'Height must be between 100 and 250 cm';

  @override
  String get validationWeight => 'Weight must be between 30 and 300 kg';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationPositiveNumber =>
      'Please enter a valid number greater than 0';

  @override
  String get bmrTitle => 'BMR Index';

  @override
  String get bmrDescription =>
      'Basal Metabolic Rate (energy burned at complete rest)';

  @override
  String get tdeeTitle => 'TDEE Index';

  @override
  String get tdeeDescription =>
      'Total Daily Energy Expenditure estimated per day';

  @override
  String get dailyCalorieTarget => 'Daily Calorie Target';

  @override
  String get dailyTargetHint => 'Default rounded to nearest 10 of TDEE';

  @override
  String get adjustTargetOptional =>
      'Adjustable to your personal fitness goals';

  @override
  String get formulaTitle => 'Calculation Formulas';

  @override
  String get formulaApplied => 'Formula applied: Mifflin-St Jeor equation';

  @override
  String get formulaBmrMifflin =>
      'Mifflin-St Jeor Formula:\n• Men: 10 × Weight(kg) + 6.25 × Height(cm) − 5 × Age + 5\n• Women: 10 × Weight(kg) + 6.25 × Height(cm) − 5 × Age − 161';

  @override
  String get formulaTdee => 'TDEE = BMR × Activity Multiplier';

  @override
  String get formulaActivityBurn =>
      'Activity Calories = MET × Weight(kg) × Duration(hours)';

  @override
  String get formulaDailyTotal =>
      'Today\'s Total Burn = BMR + Logged Activities Calories (avoids double counting)';

  @override
  String get bmrExplained =>
      'BMR is the minimum energy required to keep your body functioning at rest.';

  @override
  String get tdeeExplained =>
      'TDEE is your total energy expenditure in 24 hours including all physical activities.';

  @override
  String get dashboardTodayBurned => 'Total Calories Burned';

  @override
  String get dashboardGoal => 'Target Goal';

  @override
  String get dashboardRemaining => 'Remaining';

  @override
  String get dashboardOver => 'Exceeded';

  @override
  String get dashboardBmrPortion => 'BMR (Rest)';

  @override
  String get dashboardActivePortion => 'Active Burn';

  @override
  String get dashboardActivitiesLogged => 'Today\'s Activities';

  @override
  String get dashboardNoActivities =>
      'No activities recorded today. Tap + to add one!';

  @override
  String get dashboardAddActivity => 'Add Activity';

  @override
  String get addActivityTitle => 'Log Activity';

  @override
  String get editActivityTitle => 'Edit Activity';

  @override
  String get selectActivity => 'Select Activity';

  @override
  String get durationMinutes => 'Duration (minutes)';

  @override
  String get caloriesBurnedEstimated => 'Estimated Calories Burned';

  @override
  String get customActivity => 'Custom Activity';

  @override
  String get customActivityName => 'Activity Name';

  @override
  String get customActivityMet => 'MET Value';

  @override
  String get activitySourceNote =>
      'Based on the Compendium of Physical Activities MET database';

  @override
  String get deleteActivityConfirm =>
      'Are you sure you want to delete this activity?';

  @override
  String get historyTitle => 'Burn History';

  @override
  String get historyDay => 'Day';

  @override
  String get historyWeek => 'Week';

  @override
  String get historyMonth => 'Month';

  @override
  String get historyTotalBurned => 'Total Burned';

  @override
  String get historyAverageBurned => 'Daily Average';

  @override
  String get historyActiveMinutes => 'Active Minutes';

  @override
  String get historyNoData => 'No data recorded for this period';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfile => 'Edit Profile';

  @override
  String get settingsDailyTarget => 'Daily Calorie Target';

  @override
  String get settingsTargetUseTdee => 'Use automatic TDEE value';

  @override
  String get settingsCustomTarget => 'Custom Target (kcal)';

  @override
  String get settingsUnits => 'Measurement Units';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsClearData => 'Clear All Data';

  @override
  String get settingsClearDataConfirm =>
      'WARNING: All activity logs and user profile will be permanently deleted. Are you sure?';

  @override
  String get settingsDataClearedSuccess =>
      'All data has been successfully cleared';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String get historyHighestDay => 'Highest Day';

  @override
  String get historyDailyBurnTitle => 'Daily Calories Burned';

  @override
  String get historyDayDetailsTitle => 'Daily Breakdown (tap to view)';

  @override
  String get historyBmrOnly => 'BMR only (resting)';

  @override
  String historyActivitiesCountAndMinutes(Object count, Object minutes) {
    return '$count activities • $minutes mins';
  }

  @override
  String historyActivitiesLoggedCount(Object count) {
    return 'Logged activities ($count)';
  }

  @override
  String get historyNoActivitiesOnDay => 'No workouts recorded for this day.';

  @override
  String get historyPreviousPeriod => 'Previous period';

  @override
  String get historyNextPeriod => 'Next period';

  @override
  String get selectActivityPlease => 'Please select an activity from the list';

  @override
  String get saveToCustomTemplate => 'Save template for future reuse';

  @override
  String activityDeletedSnackbar(Object name) {
    return 'Deleted $name';
  }

  @override
  String get aboutTitle => 'About Application';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutFormulas => 'Formulas Used';

  @override
  String get aboutFormulaBmrDesc =>
      'BMR is calculated using the Mifflin-St Jeor equation (1990) based on biological sex, age, height, and weight.';

  @override
  String get aboutFormulaTdeeDesc =>
      'TDEE is estimated by multiplying BMR with the daily activity multiplier (1.2 to 1.9).';

  @override
  String get aboutFormulaActivityDesc =>
      'Activity Burn = MET × Weight(kg) × Duration(hours).';

  @override
  String get aboutFormulaTotalDesc =>
      'Daily total burn = BMR + Logged activity calories (avoids double counting).';

  @override
  String get aboutDataSource => 'MET Data Source';

  @override
  String get aboutDataSourceDesc =>
      'Compendium of Physical Activities (Ainsworth et al., University of South Carolina / Stanford).';

  @override
  String get aboutMedicalDisclaimer => 'Medical Disclaimer';

  @override
  String get aboutMedicalDisclaimerDesc =>
      'CaloOut provides estimates based on standard scientific models. It is not intended as a substitute for professional medical advice, diagnosis, or nutritional prescription.';

  @override
  String get languageSystem => 'System Default';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String get emptyStateNoActivities => 'No activities recorded yet.';

  @override
  String get errorGeneric => 'An error occurred';

  @override
  String get healthSyncTitle => 'Apple Health / Health Connect Sync';

  @override
  String get healthSyncSubtitle => 'Read active energy and step count';

  @override
  String get healthSyncPrivacyNotice =>
      'Privacy Commitment: Health and step data is read and processed strictly on your device. CaloOut never uploads or shares your health data with any external servers.';

  @override
  String get healthSyncStatusSyncing => 'Syncing health data...';

  @override
  String get healthSyncStatusAuthorized => 'Connected and synchronized';

  @override
  String get healthSyncStatusPermissionDenied =>
      'Health data access permission was denied. Please grant permission in device Settings.';

  @override
  String get healthSyncStatusPermissionRevoked =>
      'Health data access permission was revoked. Please grant permission again in system settings.';

  @override
  String get healthSyncStatusNotSupported =>
      'Device does not support Health services or Health Connect is not installed. Please install Health Connect from Google Play Store.';

  @override
  String get healthSyncStatusNoData =>
      'No new activity data found in Apple Health / Health Connect today.';

  @override
  String get healthSyncStatusReadError =>
      'Unable to read health data due to a system error. Please try again later.';

  @override
  String get healthSyncSourceAppleHealth => 'Apple Health';

  @override
  String get healthSyncSourceHealthConnect => 'Health Connect';

  @override
  String get healthSyncActivityTitle => 'Activity & Steps';

  @override
  String healthSyncActivitySubtitle(Object steps) {
    return '$steps steps • Excludes manual workout hours';
  }

  @override
  String healthSyncExcludedNote(Object count, Object kcal) {
    return 'Excluded $count samples ($kcal kcal) overlapping with manual workouts';
  }

  @override
  String get healthSyncActionInstall => 'Install Health Connect';

  @override
  String get healthSyncActionOpenSettings => 'Open Settings';
}
