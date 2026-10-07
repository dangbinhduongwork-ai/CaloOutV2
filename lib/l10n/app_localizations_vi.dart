// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

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
  String get disclaimer =>
      'Kết quả chỉ mang tính ước lượng, không thay thế tư vấn y tế.';

  @override
  String get onboardingTitle => 'Chào mừng đến với CaloOut';

  @override
  String get onboardingSubtitle =>
      'Thiết lập hồ sơ để tính chính xác chỉ số BMR và TDEE của bạn';

  @override
  String get onboardingStep1Title => 'Thông tin cơ bản';

  @override
  String get onboardingStep1Subtitle =>
      'Chọn giới tính sinh học và độ tuổi của bạn';

  @override
  String get onboardingStep2Title => 'Chiều cao & Cân nặng';

  @override
  String get onboardingStep2Subtitle => 'Nhập chỉ số thể chất của bạn';

  @override
  String get onboardingStep3Title => 'Mức độ vận động';

  @override
  String get onboardingStep3Subtitle =>
      'Thói quen hoạt động thể chất hằng ngày';

  @override
  String get onboardingResultTitle => 'Chỉ số phân tích';

  @override
  String get onboardingResultSubtitle =>
      'Năng lượng tiêu hao được tính toán riêng cho bạn';

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
  String get activitySedentaryDesc =>
      'Công việc văn phòng, ít hoặc không tập thể dục';

  @override
  String get activityLight => 'Vận động nhẹ (1.375)';

  @override
  String get activityLightDesc => 'Tập luyện nhẹ nhàng 1–3 ngày/tuần';

  @override
  String get activityModerate => 'Vận động vừa (1.55)';

  @override
  String get activityModerateDesc =>
      'Tập luyện mức độ trung bình 3–5 ngày/tuần';

  @override
  String get activityActive => 'Vận động nhiều (1.725)';

  @override
  String get activityActiveDesc => 'Tập luyện cường độ cao 6–7 ngày/tuần';

  @override
  String get activityVeryActive => 'Rất nhiều (1.9)';

  @override
  String get activityVeryActiveDesc =>
      'Vận động viên hoặc công việc lao động thể lực nặng';

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
  String get bmrDescription =>
      'Tỷ lệ trao đổi chất cơ bản (năng lượng tiêu hao lúc nghỉ ngơi)';

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
  String get formulaBmrMifflin =>
      'Công thức Mifflin-St Jeor:\n• Nam: 10 × Cân nặng(kg) + 6.25 × Chiều cao(cm) − 5 × Tuổi + 5\n• Nữ: 10 × Cân nặng(kg) + 6.25 × Chiều cao(cm) − 5 × Tuổi − 161';

  @override
  String get formulaTdee => 'TDEE = BMR × Hệ số vận động';

  @override
  String get formulaActivityBurn =>
      'Calo vận động = MET × Cân nặng(kg) × Thời gian(giờ)';

  @override
  String get formulaDailyTotal =>
      'Tổng calo tiêu hao hôm nay = BMR + Calo các hoạt động đã log (không nhân trùng hệ số)';

  @override
  String get bmrExplained =>
      'BMR là mức năng lượng tối thiểu để duy trì sự sống khi nghỉ ngơi hoàn toàn.';

  @override
  String get tdeeExplained =>
      'TDEE là tổng năng lượng tiêu thụ trong 24 giờ bao gồm mọi hoạt động.';

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
  String get dashboardNoActivities =>
      'Chưa có hoạt động nào hôm nay. Nhấn + để ghi nhận!';

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
  String get activitySourceNote =>
      'Dựa trên bảng MET Compendium of Physical Activities';

  @override
  String get deleteActivityConfirm =>
      'Bạn có chắc muốn xóa hoạt động này không?';

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
  String get settingsClearDataConfirm =>
      'CẢNH BÁO: Toàn bộ lịch sử hoạt động và hồ sơ cá nhân sẽ bị xóa vĩnh viễn. Bạn có chắc chắn không?';

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
  String historyActivitiesCountAndMinutes(Object count, Object minutes) {
    return '$count hoạt động • $minutes phút';
  }

  @override
  String historyActivitiesLoggedCount(Object count) {
    return 'Các hoạt động đã ghi ($count)';
  }

  @override
  String get historyNoActivitiesOnDay =>
      'Không có bài tập nào được ghi trong ngày này.';

  @override
  String get historyPreviousPeriod => 'Khoảng trước';

  @override
  String get historyNextPeriod => 'Khoảng sau';

  @override
  String get selectActivityPlease => 'Vui lòng chọn một hoạt động từ danh sách';

  @override
  String get saveToCustomTemplate => 'Lưu vào danh sách để dùng lại lần sau';

  @override
  String activityDeletedSnackbar(Object name) {
    return 'Đã xóa $name';
  }

  @override
  String get aboutTitle => 'Giới thiệu ứng dụng';

  @override
  String get aboutVersion => 'Phiên bản';

  @override
  String get aboutFormulas => 'Công thức tính toán';

  @override
  String get aboutFormulaBmrDesc =>
      'BMR tính theo phương trình Mifflin-St Jeor (1990) dựa trên giới tính sinh học, tuổi, chiều cao và cân nặng.';

  @override
  String get aboutFormulaTdeeDesc =>
      'TDEE ước lượng bằng BMR nhân với hệ số vận động thông thường (1.2 đến 1.9).';

  @override
  String get aboutFormulaActivityDesc =>
      'Calo vận động = MET × Cân nặng(kg) × Thời gian(giờ).';

  @override
  String get aboutFormulaTotalDesc =>
      'Tổng calo tiêu hao hàng ngày = BMR + Calo các hoạt động đã log (tránh tính trùng hệ số).';

  @override
  String get aboutDataSource => 'Nguồn dữ liệu MET';

  @override
  String get aboutDataSourceDesc =>
      'Compendium of Physical Activities (Ainsworth et al., Đại học South Carolina / Stanford).';

  @override
  String get aboutMedicalDisclaimer => 'Lưu ý y tế';

  @override
  String get aboutMedicalDisclaimerDesc =>
      'CaloOut cung cấp số liệu ước lượng dựa trên các nghiên cứu khoa học phổ biến. Ứng dụng không thay thế tư vấn y khoa, chẩn đoán hoặc phác đồ điều trị của bác sĩ và chuyên gia dinh dưỡng.';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'Tiếng Anh';

  @override
  String get emptyStateNoActivities => 'Chưa có hoạt động nào được ghi.';

  @override
  String get errorGeneric => 'Đã có lỗi xảy ra';

  @override
  String get healthSyncTitle => 'Đồng bộ Apple Health / Health Connect';

  @override
  String get healthSyncSubtitle => 'Đọc calo vận động và số bước chân';

  @override
  String get healthSyncPrivacyNotice =>
      'Cam kết quyền riêng tư: Dữ liệu vận động và bước chân chỉ được đọc và xử lý trên thiết bị của bạn. CaloOut tuyệt đối không tải hay chia sẻ dữ liệu lên bất kỳ máy chủ nào.';

  @override
  String get healthSyncStatusSyncing => 'Đang đồng bộ dữ liệu...';

  @override
  String get healthSyncStatusAuthorized => 'Đã kết nối và đồng bộ';

  @override
  String get healthSyncStatusPermissionDenied =>
      'Quyền truy cập dữ liệu sức khỏe bị từ chối. Vui lòng cấp quyền trong Cài đặt thiết bị.';

  @override
  String get healthSyncStatusPermissionRevoked =>
      'Quyền truy cập đã bị thu hồi. Vui lòng cấp lại quyền để tiếp tục đồng bộ.';

  @override
  String get healthSyncStatusNotSupported =>
      'Thiết bị không hỗ trợ hoặc chưa cài đặt ứng dụng Health Connect. Vui lòng cài đặt từ Google Play Store.';

  @override
  String get healthSyncStatusNoData =>
      'Chưa có dữ liệu vận động mới từ Apple Health / Health Connect hôm nay.';

  @override
  String get healthSyncStatusReadError =>
      'Không thể đọc dữ liệu sức khỏe do lỗi hệ thống. Vui lòng thử lại sau.';

  @override
  String get healthSyncSourceAppleHealth => 'Apple Health';

  @override
  String get healthSyncSourceHealthConnect => 'Health Connect';

  @override
  String get healthSyncActivityTitle => 'Hoạt động & Bước chân';

  @override
  String healthSyncActivitySubtitle(Object steps) {
    return '$steps bước • Tự động loại trừ giờ tập nhập tay';
  }

  @override
  String healthSyncExcludedNote(Object count, Object kcal) {
    return 'Đã loại trừ $count mẫu ($kcal kcal) trùng với giờ tập đã nhập tay';
  }

  @override
  String get healthSyncActionInstall => 'Cài đặt Health Connect';

  @override
  String get healthSyncActionOpenSettings => 'Mở Cài đặt';
}
