import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// CaloOut localization class supporting Vietnamese ('vi') and English ('en').
abstract class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(instance != null, 'No instance of AppLocalizations found in BuildContext');
    return instance!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
  ];

  // App & Common
  String get appTitle;
  String get tagline;
  String get navDashboard;
  String get navHistory;
  String get navProfile;
  String get navSettings;
  String get disclaimer;

  // Onboarding
  String get onboardingTitle;
  String get onboardingSubtitle;
  String get onboardingStep1Title;
  String get onboardingStep1Subtitle;
  String get onboardingStep2Title;
  String get onboardingStep2Subtitle;
  String get onboardingStep3Title;
  String get onboardingStep3Subtitle;
  String get onboardingResultTitle;
  String get onboardingResultSubtitle;
  String get nextStep;
  String get previousStep;
  String get finishOnboarding;
  String get getStarted;
  String get save;
  String get cancel;
  String get delete;
  String get edit;
  String get confirm;
  String get close;
  String get undo;

  // Profile & Units
  String get gender;
  String get male;
  String get female;
  String get age;
  String get ageUnit;
  String get height;
  String get weight;
  String get dailyActivityLevel;

  String get activitySedentary;
  String get activitySedentaryDesc;
  String get activityLight;
  String get activityLightDesc;
  String get activityModerate;
  String get activityModerateDesc;
  String get activityActive;
  String get activityActiveDesc;
  String get activityVeryActive;
  String get activityVeryActiveDesc;

  String get unitMetric;
  String get unitImperial;
  String get unitKg;
  String get unitLb;
  String get unitCm;
  String get unitFt;
  String get unitIn;
  String get unitMinutes;
  String get unitHours;
  String get unitKcal;

  // Validation
  String get validationAge;
  String get validationHeight;
  String get validationWeight;
  String get validationRequired;
  String get validationPositiveNumber;

  // Formula & Calculations
  String get bmrTitle;
  String get bmrDescription;
  String get tdeeTitle;
  String get tdeeDescription;
  String get dailyCalorieTarget;
  String get dailyTargetHint;
  String get adjustTargetOptional;
  String get formulaTitle;
  String get formulaApplied;
  String get formulaBmrMifflin;
  String get formulaTdee;
  String get formulaActivityBurn;
  String get formulaDailyTotal;
  String get bmrExplained;
  String get tdeeExplained;

  // Dashboard
  String get dashboardTodayBurned;
  String get dashboardGoal;
  String get dashboardRemaining;
  String get dashboardOver;
  String get dashboardBmrPortion;
  String get dashboardActivePortion;
  String get dashboardActivitiesLogged;
  String get dashboardNoActivities;
  String get dashboardAddActivity;

  // Activity Log
  String get addActivityTitle;
  String get editActivityTitle;
  String get selectActivity;
  String get durationMinutes;
  String get caloriesBurnedEstimated;
  String get customActivity;
  String get customActivityName;
  String get customActivityMet;
  String get activitySourceNote;
  String get deleteActivityConfirm;

  // History
  String get historyTitle;
  String get historyDay;
  String get historyWeek;
  String get historyMonth;
  String get historyTotalBurned;
  String get historyAverageBurned;
  String get historyActiveMinutes;
  String get historyNoData;

  // Settings
  String get settingsTitle;
  String get settingsProfile;
  String get settingsDailyTarget;
  String get settingsTargetUseTdee;
  String get settingsCustomTarget;
  String get settingsUnits;
  String get settingsLanguage;
  String get settingsTheme;
  String get settingsThemeSystem;
  String get settingsThemeLight;
  String get settingsThemeDark;
  String get settingsClearData;
  String get settingsClearDataConfirm;
  String get settingsDataClearedSuccess;

  // Additional Keys
  String get profileUpdatedSuccess;
  String get historyHighestDay;
  String get historyDailyBurnTitle;
  String get historyDayDetailsTitle;
  String get historyBmrOnly;
  String historyActivitiesCountAndMinutes(int count, int minutes);
  String historyActivitiesLoggedCount(int count);
  String get historyNoActivitiesOnDay;
  String get historyPreviousPeriod;
  String get historyNextPeriod;
  String get selectActivityPlease;
  String get saveToCustomTemplate;
  String activityDeletedSnackbar(String name);
  String get aboutTitle;
  String get aboutVersion;
  String get aboutFormulas;
  String get aboutFormulaBmrDesc;
  String get aboutFormulaTdeeDesc;
  String get aboutFormulaActivityDesc;
  String get aboutFormulaTotalDesc;
  String get aboutDataSource;
  String get aboutDataSourceDesc;
  String get aboutMedicalDisclaimer;
  String get aboutMedicalDisclaimerDesc;
  String get languageSystem;
  String get languageVietnamese;
  String get languageEnglish;
  String get emptyStateNoActivities;
  String get errorGeneric;
  String get healthSyncTitle;
  String get healthSyncSubtitle;
  String get healthSyncPrivacyNotice;
  String get healthSyncStatusSyncing;
  String get healthSyncStatusAuthorized;
  String get healthSyncStatusPermissionDenied;
  String get healthSyncStatusPermissionRevoked;
  String get healthSyncStatusNotSupported;
  String get healthSyncStatusNoData;
  String get healthSyncStatusReadError;
  String get healthSyncSourceAppleHealth;
  String get healthSyncSourceHealthConnect;
  String get healthSyncActivityTitle;
  String healthSyncActivitySubtitle(int steps);
  String healthSyncExcludedNote(int count, double kcal);
  String get healthSyncActionInstall;
  String get healthSyncActionOpenSettings;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => <String>['vi', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return SynchronousFuture<AppLocalizations>(_AppLocalizationsEn(locale));
      case 'vi':
      default:
        return SynchronousFuture<AppLocalizations>(_AppLocalizationsVi(locale));
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class _AppLocalizationsVi extends AppLocalizations {
  _AppLocalizationsVi(super.locale);

  @override
  String get appTitle => 'CaloOut';
  @override
  String get tagline => 'Theo dõi calo tiêu hao hàng ngày';
  @override
  String get navDashboard => 'Hôm nay';
  @override
  String get navHistory => 'Lịch sử';
  @override
  String get navProfile => 'Hồ sơ';
  @override
  String get navSettings => 'Cài đặt';
  @override
  String get disclaimer => 'Kết quả chỉ mang tính ước lượng, không thay thế tư vấn y tế.';

  @override
  String get onboardingTitle => 'Chào mừng đến với CaloOut';
  @override
  String get onboardingSubtitle => 'Thiết lập hồ sơ để tính chính xác chỉ số BMR và TDEE của bạn';
  @override
  String get onboardingStep1Title => 'Thông tin cơ bản';
  @override
  String get onboardingStep1Subtitle => 'Chọn giới tính sinh học và độ tuổi của bạn';
  @override
  String get onboardingStep2Title => 'Chiều cao & Cân nặng';
  @override
  String get onboardingStep2Subtitle => 'Nhập chỉ số thể chất của bạn';
  @override
  String get onboardingStep3Title => 'Mức độ vận động';
  @override
  String get onboardingStep3Subtitle => 'Thói quen hoạt động thể chất hằng ngày';
  @override
  String get onboardingResultTitle => 'Chỉ số phân tích';
  @override
  String get onboardingResultSubtitle => 'Năng lượng tiêu hao được tính toán riêng cho bạn';

  @override
  String get nextStep => 'Tiếp tục';
  @override
  String get previousStep => 'Quay lại';
  @override
  String get finishOnboarding => 'Hoàn tất & Bắt đầu';
  @override
  String get getStarted => 'Bắt đầu ngay';
  @override
  String get save => 'Lưu';
  @override
  String get cancel => 'Hủy';
  @override
  String get delete => 'Xóa';
  @override
  String get edit => 'Chỉnh sửa';
  @override
  String get confirm => 'Xác nhận';
  @override
  String get close => 'Đóng';
  @override
  String get undo => 'Hoàn tác';

  @override
  String get gender => 'Giới tính';
  @override
  String get male => 'Nam';
  @override
  String get female => 'Nữ';
  @override
  String get age => 'Tuổi';
  @override
  String get ageUnit => 'tuổi';
  @override
  String get height => 'Chiều cao';
  @override
  String get weight => 'Cân nặng';
  @override
  String get dailyActivityLevel => 'Mức độ vận động';

  @override
  String get activitySedentary => 'Ít vận động (1.2)';
  @override
  String get activitySedentaryDesc => 'Công việc văn phòng, ít hoặc không tập thể dục';
  @override
  String get activityLight => 'Vận động nhẹ (1.375)';
  @override
  String get activityLightDesc => 'Tập luyện nhẹ nhàng 1–3 ngày/tuần';
  @override
  String get activityModerate => 'Vận động vừa (1.55)';
  @override
  String get activityModerateDesc => 'Tập luyện mức độ trung bình 3–5 ngày/tuần';
  @override
  String get activityActive => 'Vận động nhiều (1.725)';
  @override
  String get activityActiveDesc => 'Tập luyện cường độ cao 6–7 ngày/tuần';
  @override
  String get activityVeryActive => 'Rất nhiều (1.9)';
  @override
  String get activityVeryActiveDesc => 'Vận động viên hoặc công việc lao động thể lực nặng';

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
  String get unitMinutes => 'phút';
  @override
  String get unitHours => 'giờ';
  @override
  String get unitKcal => 'kcal';

  @override
  String get validationAge => 'Tuổi phải từ 10 đến 100';
  @override
  String get validationHeight => 'Chiều cao phải từ 100 đến 250 cm';
  @override
  String get validationWeight => 'Cân nặng phải từ 30 đến 300 kg';
  @override
  String get validationRequired => 'Vui lòng nhập trường này';
  @override
  String get validationPositiveNumber => 'Vui lòng nhập số hợp lệ lớn hơn 0';

  @override
  String get bmrTitle => 'Chỉ số BMR';
  @override
  String get bmrDescription => 'Tỷ lệ trao đổi chất cơ bản (năng lượng tiêu hao lúc nghỉ ngơi)';
  @override
  String get tdeeTitle => 'Chỉ số TDEE';
  @override
  String get tdeeDescription => 'Tổng năng lượng tiêu hao ước tính mỗi ngày';
  @override
  String get dailyCalorieTarget => 'Mục tiêu calo / ngày';
  @override
  String get dailyTargetHint => 'Mặc định bằng TDEE làm tròn đến 10';
  @override
  String get adjustTargetOptional => 'Tùy chỉnh mục tiêu theo nhu cầu';
  @override
  String get formulaTitle => 'Công thức tính toán';
  @override
  String get formulaApplied => 'Áp dụng phương trình Mifflin-St Jeor';
  @override
  String get formulaBmrMifflin => 'Công thức Mifflin-St Jeor:\n• Nam: 10 × Cân nặng(kg) + 6.25 × Chiều cao(cm) − 5 × Tuổi + 5\n• Nữ: 10 × Cân nặng(kg) + 6.25 × Chiều cao(cm) − 5 × Tuổi − 161';
  @override
  String get formulaTdee => 'TDEE = BMR × Hệ số vận động';
  @override
  String get formulaActivityBurn => 'Calo vận động = MET × Cân nặng(kg) × Thời gian(giờ)';
  @override
  String get formulaDailyTotal => 'Tổng calo tiêu hao hôm nay = BMR + Calo các hoạt động đã log (không nhân trùng hệ số)';
  @override
  String get bmrExplained => 'BMR là mức năng lượng tối thiểu để duy trì sự sống khi nghỉ ngơi hoàn toàn.';
  @override
  String get tdeeExplained => 'TDEE là tổng năng lượng tiêu thụ trong 24 giờ bao gồm mọi hoạt động.';

  @override
  String get dashboardTodayBurned => 'Tổng calo tiêu hao';
  @override
  String get dashboardGoal => 'Mục tiêu';
  @override
  String get dashboardRemaining => 'Còn lại';
  @override
  String get dashboardOver => 'Vượt mục tiêu';
  @override
  String get dashboardBmrPortion => 'BMR (nghỉ ngơi)';
  @override
  String get dashboardActivePortion => 'Vận động';
  @override
  String get dashboardActivitiesLogged => 'Hoạt động hôm nay';
  @override
  String get dashboardNoActivities => 'Chưa có hoạt động nào hôm nay. Nhấn + để ghi nhận!';
  @override
  String get dashboardAddActivity => 'Thêm hoạt động';

  @override
  String get addActivityTitle => 'Ghi nhận hoạt động';
  @override
  String get editActivityTitle => 'Chỉnh sửa hoạt động';
  @override
  String get selectActivity => 'Chọn hoạt động';
  @override
  String get durationMinutes => 'Thời lượng (phút)';
  @override
  String get caloriesBurnedEstimated => 'Calo ước tính tiêu hao';
  @override
  String get customActivity => 'Hoạt động tùy chỉnh';
  @override
  String get customActivityName => 'Tên hoạt động';
  @override
  String get customActivityMet => 'Chỉ số MET';
  @override
  String get activitySourceNote => 'Dựa trên bảng MET Compendium of Physical Activities';
  @override
  String get deleteActivityConfirm => 'Bạn có chắc muốn xóa hoạt động này không?';

  @override
  String get historyTitle => 'Lịch sử tiêu hao';
  @override
  String get historyDay => 'Ngày';
  @override
  String get historyWeek => 'Tuần';
  @override
  String get historyMonth => 'Tháng';
  @override
  String get historyTotalBurned => 'Tổng tiêu hao';
  @override
  String get historyAverageBurned => 'Trung bình / ngày';
  @override
  String get historyActiveMinutes => 'Phút vận động';
  @override
  String get historyNoData => 'Không có dữ liệu trong khoảng thời gian này';

  @override
  String get settingsTitle => 'Cài đặt';
  @override
  String get settingsProfile => 'Chỉnh sửa hồ sơ';
  @override
  String get settingsDailyTarget => 'Mục tiêu calo hàng ngày';
  @override
  String get settingsTargetUseTdee => 'Dùng giá trị TDEE tự động';
  @override
  String get settingsCustomTarget => 'Mục tiêu tùy chỉnh (kcal)';
  @override
  String get settingsUnits => 'Đơn vị đo lường';
  @override
  String get settingsLanguage => 'Ngôn ngữ';
  @override
  String get settingsTheme => 'Giao diện';
  @override
  String get settingsThemeSystem => 'Theo hệ thống';
  @override
  String get settingsThemeLight => 'Sáng';
  @override
  String get settingsThemeDark => 'Tối';
  @override
  String get settingsClearData => 'Xóa toàn bộ dữ liệu';
  @override
  String get settingsClearDataConfirm => 'CẢNH BÁO: Toàn bộ lịch sử hoạt động và hồ sơ cá nhân sẽ bị xóa vĩnh viễn. Bạn có chắc chắn không?';
  @override
  String get settingsDataClearedSuccess => 'Đã xóa toàn bộ dữ liệu thành công';

  @override
  String get profileUpdatedSuccess => 'Cập nhật hồ sơ thành công';
  @override
  String get historyHighestDay => 'Ngày cao nhất';
  @override
  String get historyDailyBurnTitle => 'Calo tiêu hao mỗi ngày';
  @override
  String get historyDayDetailsTitle => 'Chi tiết theo ngày (chạm để xem)';
  @override
  String get historyBmrOnly => 'Chỉ có BMR (nghỉ ngơi)';
  @override
  String historyActivitiesCountAndMinutes(int count, int minutes) => '$count hoạt động • $minutes phút';
  @override
  String historyActivitiesLoggedCount(int count) => 'Các hoạt động đã ghi ($count)';
  @override
  String get historyNoActivitiesOnDay => 'Không có bài tập nào được ghi trong ngày này.';
  @override
  String get historyPreviousPeriod => 'Khoảng trước';
  @override
  String get historyNextPeriod => 'Khoảng sau';
  @override
  String get selectActivityPlease => 'Vui lòng chọn một hoạt động từ danh sách';
  @override
  String get saveToCustomTemplate => 'Lưu vào danh sách để dùng lại lần sau';
  @override
  String activityDeletedSnackbar(String name) => 'Đã xóa $name';
  @override
  String get aboutTitle => 'Giới thiệu ứng dụng';
  @override
  String get aboutVersion => 'Phiên bản';
  @override
  String get aboutFormulas => 'Công thức tính toán';
  @override
  String get aboutFormulaBmrDesc => 'BMR tính theo phương trình Mifflin-St Jeor (1990) dựa trên giới tính sinh học, tuổi, chiều cao và cân nặng.';
  @override
  String get aboutFormulaTdeeDesc => 'TDEE ước lượng bằng BMR nhân với hệ số vận động thông thường (1.2 đến 1.9).';
  @override
  String get aboutFormulaActivityDesc => 'Calo vận động = MET × Cân nặng(kg) × Thời gian(giờ).';
  @override
  String get aboutFormulaTotalDesc => 'Tổng calo tiêu hao hàng ngày = BMR + Calo các hoạt động đã log (tránh tính trùng hệ số).';
  @override
  String get aboutDataSource => 'Nguồn dữ liệu MET';
  @override
  String get aboutDataSourceDesc => 'Compendium of Physical Activities (Ainsworth et al., Đại học South Carolina / Stanford).';
  @override
  String get aboutMedicalDisclaimer => 'Lưu ý y tế';
  @override
  String get aboutMedicalDisclaimerDesc => 'CaloOut cung cấp số liệu ước lượng dựa trên các nghiên cứu khoa học phổ biến. Ứng dụng không thay thế tư vấn y khoa, chẩn đoán hoặc phác đồ điều trị của bác sĩ và chuyên gia dinh dưỡng.';
  @override
  String get languageSystem => 'Theo hệ thống';
  @override
  String get languageVietnamese => 'Tiếng Việt';
  @override
  String get languageEnglish => 'English';
  @override
  String get emptyStateNoActivities => 'Chưa có hoạt động nào được ghi.';
  @override
  String get errorGeneric => 'Đã có lỗi xảy ra';
  @override
  String get healthSyncTitle => 'Đồng bộ Apple Health / Health Connect';
  @override
  String get healthSyncSubtitle => 'Đọc calo vận động và số bước chân';
  @override
  String get healthSyncPrivacyNotice => 'Cam kết quyền riêng tư: Dữ liệu vận động và bước chân chỉ được đọc và xử lý trên thiết bị của bạn. CaloOut tuyệt đối không tải hay chia sẻ dữ liệu lên bất kỳ máy chủ nào.';
  @override
  String get healthSyncStatusSyncing => 'Đang đồng bộ dữ liệu...';
  @override
  String get healthSyncStatusAuthorized => 'Đã kết nối và đồng bộ';
  @override
  String get healthSyncStatusPermissionDenied => 'Quyền truy cập dữ liệu sức khỏe bị từ chối. Vui lòng cấp quyền trong Cài đặt thiết bị.';
  @override
  String get healthSyncStatusPermissionRevoked => 'Quyền truy cập đã bị thu hồi. Vui lòng cấp lại quyền để tiếp tục đồng bộ.';
  @override
  String get healthSyncStatusNotSupported => 'Thiết bị không hỗ trợ hoặc chưa cài đặt ứng dụng Health Connect. Vui lòng cài đặt từ Google Play Store.';
  @override
  String get healthSyncStatusNoData => 'Chưa có dữ liệu vận động mới từ Apple Health / Health Connect hôm nay.';
  @override
  String get healthSyncStatusReadError => 'Không thể đọc dữ liệu sức khỏe do lỗi hệ thống. Vui lòng thử lại sau.';
  @override
  String get healthSyncSourceAppleHealth => 'Apple Health';
  @override
  String get healthSyncSourceHealthConnect => 'Health Connect';
  @override
  String get healthSyncActivityTitle => 'Hoạt động & Bước chân';
  @override
  String healthSyncActivitySubtitle(int steps) => '$steps bước • Tự động loại trừ giờ tập nhập tay';
  @override
  String healthSyncExcludedNote(int count, double kcal) => 'Đã loại trừ $count mẫu (${kcal.toStringAsFixed(0)} kcal) trùng với giờ tập đã nhập tay';
  @override
  String get healthSyncActionInstall => 'Cài đặt Health Connect';
  @override
  String get healthSyncActionOpenSettings => 'Mở Cài đặt';
}

class _AppLocalizationsEn extends AppLocalizations {
  _AppLocalizationsEn(super.locale);

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
  String get disclaimer => 'Results are estimates only and do not replace professional medical advice.';

  @override
  String get onboardingTitle => 'Welcome to CaloOut';
  @override
  String get onboardingSubtitle => 'Set up your profile to calculate accurate BMR and TDEE metrics';
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
  String get onboardingStep3Subtitle => 'Your daily physical habits and exercise routine';
  @override
  String get onboardingResultTitle => 'Your Metrics';
  @override
  String get onboardingResultSubtitle => 'Caloric burn calculated specifically for your body';

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
  String get validationPositiveNumber => 'Please enter a valid number greater than 0';

  @override
  String get bmrTitle => 'BMR Index';
  @override
  String get bmrDescription => 'Basal Metabolic Rate (energy burned at complete rest)';
  @override
  String get tdeeTitle => 'TDEE Index';
  @override
  String get tdeeDescription => 'Total Daily Energy Expenditure estimated per day';
  @override
  String get dailyCalorieTarget => 'Daily Calorie Target';
  @override
  String get dailyTargetHint => 'Default rounded to nearest 10 of TDEE';
  @override
  String get adjustTargetOptional => 'Adjustable to your personal fitness goals';
  @override
  String get formulaTitle => 'Calculation Formulas';
  @override
  String get formulaApplied => 'Formula applied: Mifflin-St Jeor equation';
  @override
  String get formulaBmrMifflin => 'Mifflin-St Jeor Formula:\n• Men: 10 × Weight(kg) + 6.25 × Height(cm) − 5 × Age + 5\n• Women: 10 × Weight(kg) + 6.25 × Height(cm) − 5 × Age − 161';
  @override
  String get formulaTdee => 'TDEE = BMR × Activity Multiplier';
  @override
  String get formulaActivityBurn => 'Activity Calories = MET × Weight(kg) × Duration(hours)';
  @override
  String get formulaDailyTotal => 'Today\'s Total Burn = BMR + Logged Activities Calories (avoids double counting)';
  @override
  String get bmrExplained => 'BMR is the minimum energy required to keep your body functioning at rest.';
  @override
  String get tdeeExplained => 'TDEE is your total energy expenditure in 24 hours including all physical activities.';

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
  String get dashboardNoActivities => 'No activities recorded today. Tap + to add one!';
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
  String get activitySourceNote => 'Based on the Compendium of Physical Activities MET database';
  @override
  String get deleteActivityConfirm => 'Are you sure you want to delete this activity?';

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
  String get settingsClearDataConfirm => 'WARNING: All activity logs and user profile will be permanently deleted. Are you sure?';
  @override
  String get settingsDataClearedSuccess => 'All data has been successfully cleared';

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
  String historyActivitiesCountAndMinutes(int count, int minutes) => '$count activities • $minutes mins';
  @override
  String historyActivitiesLoggedCount(int count) => 'Logged activities ($count)';
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
  String activityDeletedSnackbar(String name) => 'Deleted $name';
  @override
  String get aboutTitle => 'About Application';
  @override
  String get aboutVersion => 'Version';
  @override
  String get aboutFormulas => 'Formulas Used';
  @override
  String get aboutFormulaBmrDesc => 'BMR is calculated using the Mifflin-St Jeor equation (1990) based on biological sex, age, height, and weight.';
  @override
  String get aboutFormulaTdeeDesc => 'TDEE is estimated by multiplying BMR with the daily activity multiplier (1.2 to 1.9).';
  @override
  String get aboutFormulaActivityDesc => 'Activity Burn = MET × Weight(kg) × Duration(hours).';
  @override
  String get aboutFormulaTotalDesc => 'Daily total burn = BMR + Logged activity calories (avoids double counting).';
  @override
  String get aboutDataSource => 'MET Data Source';
  @override
  String get aboutDataSourceDesc => 'Compendium of Physical Activities (Ainsworth et al., University of South Carolina / Stanford).';
  @override
  String get aboutMedicalDisclaimer => 'Medical Disclaimer';
  @override
  String get aboutMedicalDisclaimerDesc => 'CaloOut provides estimates based on standard scientific research. It is not intended as a substitute for professional medical advice, diagnosis, or nutritional prescription.';
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
  String get healthSyncPrivacyNotice => 'Privacy Commitment: Health and step data is read and processed strictly on your device. CaloOut never uploads or shares your health data with any external servers.';
  @override
  String get healthSyncStatusSyncing => 'Syncing health data...';
  @override
  String get healthSyncStatusAuthorized => 'Connected and synchronized';
  @override
  String get healthSyncStatusPermissionDenied => 'Health data access permission was denied. Please grant permission in device Settings.';
  @override
  String get healthSyncStatusPermissionRevoked => 'Health data access permission was revoked. Please grant permission again in system settings.';
  @override
  String get healthSyncStatusNotSupported => 'Device does not support Health services or Health Connect is not installed. Please install Health Connect from Google Play Store.';
  @override
  String get healthSyncStatusNoData => 'No new activity data found in Apple Health / Health Connect today.';
  @override
  String get healthSyncStatusReadError => 'Unable to read health data due to a system error. Please try again later.';
  @override
  String get healthSyncSourceAppleHealth => 'Apple Health';
  @override
  String get healthSyncSourceHealthConnect => 'Health Connect';
  @override
  String get healthSyncActivityTitle => 'Activity & Steps';
  @override
  String healthSyncActivitySubtitle(int steps) => '$steps steps • Excludes manual workout hours';
  @override
  String healthSyncExcludedNote(int count, double kcal) => 'Excluded $count samples (${kcal.toStringAsFixed(0)} kcal) overlapping with manual workouts';
  @override
  String get healthSyncActionInstall => 'Install Health Connect';
  @override
  String get healthSyncActionOpenSettings => 'Open Settings';
}
