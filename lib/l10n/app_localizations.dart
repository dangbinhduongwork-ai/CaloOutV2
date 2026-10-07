import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'CaloOut'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi calo tiêu hao hàng ngày'**
  String get tagline;

  /// No description provided for @navDashboard.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get navDashboard;

  /// No description provided for @navHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get navSettings;

  /// No description provided for @disclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Kết quả chỉ mang tính ước lượng, không thay thế tư vấn y tế.'**
  String get disclaimer;

  /// No description provided for @onboardingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đến với CaloOut'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập hồ sơ để tính chính xác chỉ số BMR và TDEE của bạn'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingStep1Title.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get onboardingStep1Title;

  /// No description provided for @onboardingStep1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giới tính sinh học và độ tuổi của bạn'**
  String get onboardingStep1Subtitle;

  /// No description provided for @onboardingStep2Title.
  ///
  /// In vi, this message translates to:
  /// **'Chiều cao & Cân nặng'**
  String get onboardingStep2Title;

  /// No description provided for @onboardingStep2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập chỉ số thể chất của bạn'**
  String get onboardingStep2Subtitle;

  /// No description provided for @onboardingStep3Title.
  ///
  /// In vi, this message translates to:
  /// **'Mức độ vận động'**
  String get onboardingStep3Title;

  /// No description provided for @onboardingStep3Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thói quen hoạt động thể chất hằng ngày'**
  String get onboardingStep3Subtitle;

  /// No description provided for @onboardingResultTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số phân tích'**
  String get onboardingResultTitle;

  /// No description provided for @onboardingResultSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Năng lượng tiêu hao được tính toán riêng cho bạn'**
  String get onboardingResultSubtitle;

  /// No description provided for @nextStep.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get nextStep;

  /// No description provided for @previousStep.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get previousStep;

  /// No description provided for @finishOnboarding.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất & Bắt đầu'**
  String get finishOnboarding;

  /// No description provided for @getStarted.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu ngay'**
  String get getStarted;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @undo.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tác'**
  String get undo;

  /// No description provided for @gender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In vi, this message translates to:
  /// **'Nam'**
  String get male;

  /// No description provided for @female.
  ///
  /// In vi, this message translates to:
  /// **'Nữ'**
  String get female;

  /// No description provided for @age.
  ///
  /// In vi, this message translates to:
  /// **'Tuổi'**
  String get age;

  /// No description provided for @ageUnit.
  ///
  /// In vi, this message translates to:
  /// **'tuổi'**
  String get ageUnit;

  /// No description provided for @height.
  ///
  /// In vi, this message translates to:
  /// **'Chiều cao'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng'**
  String get weight;

  /// No description provided for @dailyActivityLevel.
  ///
  /// In vi, this message translates to:
  /// **'Mức độ vận động'**
  String get dailyActivityLevel;

  /// No description provided for @activitySedentary.
  ///
  /// In vi, this message translates to:
  /// **'Ít vận động (1.2)'**
  String get activitySedentary;

  /// No description provided for @activitySedentaryDesc.
  ///
  /// In vi, this message translates to:
  /// **'Công việc văn phòng, ít hoặc không tập thể dục'**
  String get activitySedentaryDesc;

  /// No description provided for @activityLight.
  ///
  /// In vi, this message translates to:
  /// **'Vận động nhẹ (1.375)'**
  String get activityLight;

  /// No description provided for @activityLightDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tập luyện nhẹ nhàng 1–3 ngày/tuần'**
  String get activityLightDesc;

  /// No description provided for @activityModerate.
  ///
  /// In vi, this message translates to:
  /// **'Vận động vừa (1.55)'**
  String get activityModerate;

  /// No description provided for @activityModerateDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tập luyện mức độ trung bình 3–5 ngày/tuần'**
  String get activityModerateDesc;

  /// No description provided for @activityActive.
  ///
  /// In vi, this message translates to:
  /// **'Vận động nhiều (1.725)'**
  String get activityActive;

  /// No description provided for @activityActiveDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tập luyện cường độ cao 6–7 ngày/tuần'**
  String get activityActiveDesc;

  /// No description provided for @activityVeryActive.
  ///
  /// In vi, this message translates to:
  /// **'Rất nhiều (1.9)'**
  String get activityVeryActive;

  /// No description provided for @activityVeryActiveDesc.
  ///
  /// In vi, this message translates to:
  /// **'Vận động viên hoặc công việc lao động thể lực nặng'**
  String get activityVeryActiveDesc;

  /// No description provided for @unitMetric.
  ///
  /// In vi, this message translates to:
  /// **'Metric (kg, cm)'**
  String get unitMetric;

  /// No description provided for @unitImperial.
  ///
  /// In vi, this message translates to:
  /// **'Imperial (lb, ft-in)'**
  String get unitImperial;

  /// No description provided for @unitKg.
  ///
  /// In vi, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In vi, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// No description provided for @unitCm.
  ///
  /// In vi, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitFt.
  ///
  /// In vi, this message translates to:
  /// **'ft'**
  String get unitFt;

  /// No description provided for @unitIn.
  ///
  /// In vi, this message translates to:
  /// **'in'**
  String get unitIn;

  /// No description provided for @unitMinutes.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get unitMinutes;

  /// No description provided for @unitHours.
  ///
  /// In vi, this message translates to:
  /// **'giờ'**
  String get unitHours;

  /// No description provided for @unitKcal.
  ///
  /// In vi, this message translates to:
  /// **'kcal'**
  String get unitKcal;

  /// No description provided for @validationAge.
  ///
  /// In vi, this message translates to:
  /// **'Tuổi phải từ 10 đến 100'**
  String get validationAge;

  /// No description provided for @validationHeight.
  ///
  /// In vi, this message translates to:
  /// **'Chiều cao phải từ 100 đến 250 cm'**
  String get validationHeight;

  /// No description provided for @validationWeight.
  ///
  /// In vi, this message translates to:
  /// **'Cân nặng phải từ 30 đến 300 kg'**
  String get validationWeight;

  /// No description provided for @validationRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập trường này'**
  String get validationRequired;

  /// No description provided for @validationPositiveNumber.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số hợp lệ lớn hơn 0'**
  String get validationPositiveNumber;

  /// No description provided for @bmrTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số BMR'**
  String get bmrTitle;

  /// No description provided for @bmrDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ trao đổi chất cơ bản (năng lượng tiêu hao lúc nghỉ ngơi)'**
  String get bmrDescription;

  /// No description provided for @tdeeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số TDEE'**
  String get tdeeTitle;

  /// No description provided for @tdeeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tổng năng lượng tiêu hao ước tính mỗi ngày'**
  String get tdeeDescription;

  /// No description provided for @dailyCalorieTarget.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu calo / ngày'**
  String get dailyCalorieTarget;

  /// No description provided for @dailyTargetHint.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định bằng TDEE làm tròn đến 10'**
  String get dailyTargetHint;

  /// No description provided for @adjustTargetOptional.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chỉnh mục tiêu theo nhu cầu'**
  String get adjustTargetOptional;

  /// No description provided for @formulaTitle.
  ///
  /// In vi, this message translates to:
  /// **'Công thức tính toán'**
  String get formulaTitle;

  /// No description provided for @formulaApplied.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng phương trình Mifflin-St Jeor'**
  String get formulaApplied;

  /// No description provided for @formulaBmrMifflin.
  ///
  /// In vi, this message translates to:
  /// **'Công thức Mifflin-St Jeor:\n• Nam: 10 × Cân nặng(kg) + 6.25 × Chiều cao(cm) − 5 × Tuổi + 5\n• Nữ: 10 × Cân nặng(kg) + 6.25 × Chiều cao(cm) − 5 × Tuổi − 161'**
  String get formulaBmrMifflin;

  /// No description provided for @formulaTdee.
  ///
  /// In vi, this message translates to:
  /// **'TDEE = BMR × Hệ số vận động'**
  String get formulaTdee;

  /// No description provided for @formulaActivityBurn.
  ///
  /// In vi, this message translates to:
  /// **'Calo vận động = MET × Cân nặng(kg) × Thời gian(giờ)'**
  String get formulaActivityBurn;

  /// No description provided for @formulaDailyTotal.
  ///
  /// In vi, this message translates to:
  /// **'Tổng calo tiêu hao hôm nay = BMR + Calo các hoạt động đã log (không nhân trùng hệ số)'**
  String get formulaDailyTotal;

  /// No description provided for @bmrExplained.
  ///
  /// In vi, this message translates to:
  /// **'BMR là mức năng lượng tối thiểu để duy trì sự sống khi nghỉ ngơi hoàn toàn.'**
  String get bmrExplained;

  /// No description provided for @tdeeExplained.
  ///
  /// In vi, this message translates to:
  /// **'TDEE là tổng năng lượng tiêu thụ trong 24 giờ bao gồm mọi hoạt động.'**
  String get tdeeExplained;

  /// No description provided for @dashboardTodayBurned.
  ///
  /// In vi, this message translates to:
  /// **'Tổng calo tiêu hao'**
  String get dashboardTodayBurned;

  /// No description provided for @dashboardGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu'**
  String get dashboardGoal;

  /// No description provided for @dashboardRemaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn lại'**
  String get dashboardRemaining;

  /// No description provided for @dashboardOver.
  ///
  /// In vi, this message translates to:
  /// **'Vượt mục tiêu'**
  String get dashboardOver;

  /// No description provided for @dashboardBmrPortion.
  ///
  /// In vi, this message translates to:
  /// **'BMR (nghỉ ngơi)'**
  String get dashboardBmrPortion;

  /// No description provided for @dashboardActivePortion.
  ///
  /// In vi, this message translates to:
  /// **'Vận động'**
  String get dashboardActivePortion;

  /// No description provided for @dashboardActivitiesLogged.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động hôm nay'**
  String get dashboardActivitiesLogged;

  /// No description provided for @dashboardNoActivities.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có hoạt động nào hôm nay. Nhấn + để ghi nhận!'**
  String get dashboardNoActivities;

  /// No description provided for @dashboardAddActivity.
  ///
  /// In vi, this message translates to:
  /// **'Thêm hoạt động'**
  String get dashboardAddActivity;

  /// No description provided for @addActivityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận hoạt động'**
  String get addActivityTitle;

  /// No description provided for @editActivityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hoạt động'**
  String get editActivityTitle;

  /// No description provided for @selectActivity.
  ///
  /// In vi, this message translates to:
  /// **'Chọn hoạt động'**
  String get selectActivity;

  /// No description provided for @durationMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Thời lượng (phút)'**
  String get durationMinutes;

  /// No description provided for @caloriesBurnedEstimated.
  ///
  /// In vi, this message translates to:
  /// **'Calo ước tính tiêu hao'**
  String get caloriesBurnedEstimated;

  /// No description provided for @customActivity.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động tùy chỉnh'**
  String get customActivity;

  /// No description provided for @customActivityName.
  ///
  /// In vi, this message translates to:
  /// **'Tên hoạt động'**
  String get customActivityName;

  /// No description provided for @customActivityMet.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số MET'**
  String get customActivityMet;

  /// No description provided for @activitySourceNote.
  ///
  /// In vi, this message translates to:
  /// **'Dựa trên bảng MET Compendium of Physical Activities'**
  String get activitySourceNote;

  /// No description provided for @deleteActivityConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa hoạt động này không?'**
  String get deleteActivityConfirm;

  /// No description provided for @historyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử tiêu hao'**
  String get historyTitle;

  /// No description provided for @historyDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get historyDay;

  /// No description provided for @historyWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get historyWeek;

  /// No description provided for @historyMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get historyMonth;

  /// No description provided for @historyTotalBurned.
  ///
  /// In vi, this message translates to:
  /// **'Tổng tiêu hao'**
  String get historyTotalBurned;

  /// No description provided for @historyAverageBurned.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình / ngày'**
  String get historyAverageBurned;

  /// No description provided for @historyActiveMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Phút vận động'**
  String get historyActiveMinutes;

  /// No description provided for @historyNoData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu trong khoảng thời gian này'**
  String get historyNoData;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @settingsProfile.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get settingsProfile;

  /// No description provided for @settingsDailyTarget.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu calo hàng ngày'**
  String get settingsDailyTarget;

  /// No description provided for @settingsTargetUseTdee.
  ///
  /// In vi, this message translates to:
  /// **'Dùng giá trị TDEE tự động'**
  String get settingsTargetUseTdee;

  /// No description provided for @settingsCustomTarget.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu tùy chỉnh (kcal)'**
  String get settingsCustomTarget;

  /// No description provided for @settingsUnits.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị đo lường'**
  String get settingsUnits;

  /// No description provided for @settingsLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get settingsThemeDark;

  /// No description provided for @settingsClearData.
  ///
  /// In vi, this message translates to:
  /// **'Xóa toàn bộ dữ liệu'**
  String get settingsClearData;

  /// No description provided for @settingsClearDataConfirm.
  ///
  /// In vi, this message translates to:
  /// **'CẢNH BÁO: Toàn bộ lịch sử hoạt động và hồ sơ cá nhân sẽ bị xóa vĩnh viễn. Bạn có chắc chắn không?'**
  String get settingsClearDataConfirm;

  /// No description provided for @settingsDataClearedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa toàn bộ dữ liệu thành công'**
  String get settingsDataClearedSuccess;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật hồ sơ thành công'**
  String get profileUpdatedSuccess;

  /// No description provided for @historyHighestDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày cao nhất'**
  String get historyHighestDay;

  /// No description provided for @historyDailyBurnTitle.
  ///
  /// In vi, this message translates to:
  /// **'Calo tiêu hao mỗi ngày'**
  String get historyDailyBurnTitle;

  /// No description provided for @historyDayDetailsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết theo ngày (chạm để xem)'**
  String get historyDayDetailsTitle;

  /// No description provided for @historyBmrOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ có BMR (nghỉ ngơi)'**
  String get historyBmrOnly;

  /// No description provided for @historyActivitiesCountAndMinutes.
  ///
  /// In vi, this message translates to:
  /// **'{count} hoạt động • {minutes} phút'**
  String historyActivitiesCountAndMinutes(Object count, Object minutes);

  /// No description provided for @historyActivitiesLoggedCount.
  ///
  /// In vi, this message translates to:
  /// **'Các hoạt động đã ghi ({count})'**
  String historyActivitiesLoggedCount(Object count);

  /// No description provided for @historyNoActivitiesOnDay.
  ///
  /// In vi, this message translates to:
  /// **'Không có bài tập nào được ghi trong ngày này.'**
  String get historyNoActivitiesOnDay;

  /// No description provided for @historyPreviousPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng trước'**
  String get historyPreviousPeriod;

  /// No description provided for @historyNextPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng sau'**
  String get historyNextPeriod;

  /// No description provided for @selectActivityPlease.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn một hoạt động từ danh sách'**
  String get selectActivityPlease;

  /// No description provided for @saveToCustomTemplate.
  ///
  /// In vi, this message translates to:
  /// **'Lưu vào danh sách để dùng lại lần sau'**
  String get saveToCustomTemplate;

  /// No description provided for @activityDeletedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa {name}'**
  String activityDeletedSnackbar(Object name);

  /// No description provided for @aboutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu ứng dụng'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get aboutVersion;

  /// No description provided for @aboutFormulas.
  ///
  /// In vi, this message translates to:
  /// **'Công thức tính toán'**
  String get aboutFormulas;

  /// No description provided for @aboutFormulaBmrDesc.
  ///
  /// In vi, this message translates to:
  /// **'BMR tính theo phương trình Mifflin-St Jeor (1990) dựa trên giới tính sinh học, tuổi, chiều cao và cân nặng.'**
  String get aboutFormulaBmrDesc;

  /// No description provided for @aboutFormulaTdeeDesc.
  ///
  /// In vi, this message translates to:
  /// **'TDEE ước lượng bằng BMR nhân với hệ số vận động thông thường (1.2 đến 1.9).'**
  String get aboutFormulaTdeeDesc;

  /// No description provided for @aboutFormulaActivityDesc.
  ///
  /// In vi, this message translates to:
  /// **'Calo vận động = MET × Cân nặng(kg) × Thời gian(giờ).'**
  String get aboutFormulaActivityDesc;

  /// No description provided for @aboutFormulaTotalDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tổng calo tiêu hao hàng ngày = BMR + Calo các hoạt động đã log (tránh tính trùng hệ số).'**
  String get aboutFormulaTotalDesc;

  /// No description provided for @aboutDataSource.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn dữ liệu MET'**
  String get aboutDataSource;

  /// No description provided for @aboutDataSourceDesc.
  ///
  /// In vi, this message translates to:
  /// **'Compendium of Physical Activities (Ainsworth et al., Đại học South Carolina / Stanford).'**
  String get aboutDataSourceDesc;

  /// No description provided for @aboutMedicalDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý y tế'**
  String get aboutMedicalDisclaimer;

  /// No description provided for @aboutMedicalDisclaimerDesc.
  ///
  /// In vi, this message translates to:
  /// **'CaloOut cung cấp số liệu ước lượng dựa trên các nghiên cứu khoa học phổ biến. Ứng dụng không thay thế tư vấn y khoa, chẩn đoán hoặc phác đồ điều trị của bác sĩ và chuyên gia dinh dưỡng.'**
  String get aboutMedicalDisclaimerDesc;

  /// No description provided for @languageSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get languageSystem;

  /// No description provided for @languageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Anh'**
  String get languageEnglish;

  /// No description provided for @emptyStateNoActivities.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có hoạt động nào được ghi.'**
  String get emptyStateNoActivities;

  /// No description provided for @errorGeneric.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get errorGeneric;

  /// No description provided for @healthSyncTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đồng bộ Apple Health / Health Connect'**
  String get healthSyncTitle;

  /// No description provided for @healthSyncSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đọc calo vận động và số bước chân'**
  String get healthSyncSubtitle;

  /// No description provided for @healthSyncPrivacyNotice.
  ///
  /// In vi, this message translates to:
  /// **'Cam kết quyền riêng tư: Dữ liệu vận động và bước chân chỉ được đọc và xử lý trên thiết bị của bạn. CaloOut tuyệt đối không tải hay chia sẻ dữ liệu lên bất kỳ máy chủ nào.'**
  String get healthSyncPrivacyNotice;

  /// No description provided for @healthSyncStatusSyncing.
  ///
  /// In vi, this message translates to:
  /// **'Đang đồng bộ dữ liệu...'**
  String get healthSyncStatusSyncing;

  /// No description provided for @healthSyncStatusAuthorized.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết nối và đồng bộ'**
  String get healthSyncStatusAuthorized;

  /// No description provided for @healthSyncStatusPermissionDenied.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập dữ liệu sức khỏe bị từ chối. Vui lòng cấp quyền trong Cài đặt thiết bị.'**
  String get healthSyncStatusPermissionDenied;

  /// No description provided for @healthSyncStatusPermissionRevoked.
  ///
  /// In vi, this message translates to:
  /// **'Quyền truy cập đã bị thu hồi. Vui lòng cấp lại quyền để tiếp tục đồng bộ.'**
  String get healthSyncStatusPermissionRevoked;

  /// No description provided for @healthSyncStatusNotSupported.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị không hỗ trợ hoặc chưa cài đặt ứng dụng Health Connect. Vui lòng cài đặt từ Google Play Store.'**
  String get healthSyncStatusNotSupported;

  /// No description provided for @healthSyncStatusNoData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu vận động mới từ Apple Health / Health Connect hôm nay.'**
  String get healthSyncStatusNoData;

  /// No description provided for @healthSyncStatusReadError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đọc dữ liệu sức khỏe do lỗi hệ thống. Vui lòng thử lại sau.'**
  String get healthSyncStatusReadError;

  /// No description provided for @healthSyncSourceAppleHealth.
  ///
  /// In vi, this message translates to:
  /// **'Apple Health'**
  String get healthSyncSourceAppleHealth;

  /// No description provided for @healthSyncSourceHealthConnect.
  ///
  /// In vi, this message translates to:
  /// **'Health Connect'**
  String get healthSyncSourceHealthConnect;

  /// No description provided for @healthSyncActivityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động & Bước chân'**
  String get healthSyncActivityTitle;

  /// No description provided for @healthSyncActivitySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{steps} bước • Tự động loại trừ giờ tập nhập tay'**
  String healthSyncActivitySubtitle(Object steps);

  /// No description provided for @healthSyncExcludedNote.
  ///
  /// In vi, this message translates to:
  /// **'Đã loại trừ {count} mẫu ({kcal} kcal) trùng với giờ tập đã nhập tay'**
  String healthSyncExcludedNote(Object count, Object kcal);

  /// No description provided for @healthSyncActionInstall.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt Health Connect'**
  String get healthSyncActionInstall;

  /// No description provided for @healthSyncActionOpenSettings.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt'**
  String get healthSyncActionOpenSettings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
