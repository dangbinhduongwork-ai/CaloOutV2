# CaloOut - Daily Calories Out Tracker

CaloOut là ứng dụng di động (Flutter) chuyên theo dõi và tính toán **lượng calo tiêu hao (calories out)** mỗi ngày:
- **BMR (Basal Metabolic Rate)**: Calo tiêu hao khi cơ thể nghỉ ngơi (tính theo công thức Mifflin-St Jeor).
- **TDEE (Total Daily Energy Expenditure)**: Tổng calo tiêu hao ước tính dựa trên mức độ vận động thông thường.
- **Calo vận động**: Calo đốt cháy từ các hoạt động thể chất, thể thao, tập luyện theo chỉ số MET chuẩn từ Compendium of Physical Activities.
- **Hoạt động 100% offline**: Dữ liệu lưu cục bộ trên thiết bị qua Drift (SQLite) và SharedPreferences, không yêu cầu đăng nhập hay kết nối Internet.
- **Đa ngôn ngữ**: Hỗ trợ đầy đủ Tiếng Việt và Tiếng Anh.

---

## 🛠 Công nghệ & Kiến trúc
- **Framework**: Flutter + Dart null-safety, Material 3, hỗ trợ cả Light & Dark mode.
- **Kiến trúc**: Clean Architecture theo tầng (Domain -> Data -> Presentation), chia theo Feature (`profile`, `activity`, `history`, `dashboard`, `settings`).
- **State Management**: `flutter_riverpod` (v2).
- **Navigation**: `go_router` với `StatefulShellRoute.indexedStack` (giữ nguyên trạng thái và vị trí cuộn của từng tab).
- **Database & Lưu trữ**:
  - `drift` & `drift_flutter` (SQLite với `sqlite3_flutter_libs`) lưu nhật ký hoạt động `activity_logs`.
  - `shared_preferences` lưu hồ sơ người dùng và cài đặt đơn vị.
- **Biểu đồ**: `fl_chart` (stacked bar chart với đường kẻ mục tiêu và tooltip tương tác).
- **Đa ngôn ngữ (i18n/l10n)**: `flutter_localizations` & `intl` (`.arb`).

---

## 🚀 Hướng dẫn Cài đặt & Chạy

### 1. Cài đặt dependencies
```bash
flutter pub get
```

### 2. Sinh mã Drift / SQLite (khi thay đổi schema database)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Kiểm tra chất lượng mã & Tests
```bash
flutter analyze
flutter test
```

### 4. Khởi chạy ứng dụng
```bash
flutter run
```

---

## 📌 Các giả định nghiệp vụ quan trọng (Assumptions)
1. **Tránh tính trùng lặp calo (No Double Counting)**:
   - Tổng calo tiêu hao trong ngày được tính chính xác bằng công thức:
     $$\text{Total Burn} = \text{BMR} + \text{Activity Kcal}$$
   - Không lấy TDEE cộng thêm Calo tập luyện, vì TDEE đã bao gồm hệ số vận động trung bình.
2. **Tính toán lịch sử BMR và Calo hoạt động**:
   - **BMR ngày quá khứ**: Được tính toán dựa trên hồ sơ người dùng hiện tại (cân nặng, chiều cao, tuổi, giới tính hiện tại).
   - **Calo hoạt động đã ghi**: Sử dụng giá trị snapshot đã tính và lưu tại thời điểm ghi (`caloriesBurned` và `weightKgSnapshot`). Việc cập nhật cân nặng trong hồ sơ sau này sẽ không làm thay đổi các giá trị đã ghi nhận trong quá khứ.
3. **Phạm vi hiển thị & điều hướng**:
   - Tuần bắt đầu từ **thứ Hai** và kết thúc vào **Chủ Nhật** theo chuẩn ISO-8601.
   - Ứng dụng khóa không cho phép điều hướng tới các khoảng thời gian tương lai (`canGoForwardProvider`).
   - Mọi ngày trong khoảng được chọn đều được liệt kê đầy đủ. Những ngày không có hoạt động vẫn hiển thị với `activityKcal = 0` và `total = BMR`.
4. **Dữ liệu mẫu Debug (60 ngày)**:
   - Nút sinh dữ liệu mẫu 60 ngày (`debugSeedSampleHistoryData`) chỉ xuất hiện trong môi trường kiểm thử/phát triển (`kDebugMode`) và tự động bị loại bỏ hoàn toàn trong bản build Release.
