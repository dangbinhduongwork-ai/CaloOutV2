# CaloOut - Daily Calories Out Tracker

**CaloOut** là ứng dụng di động Flutter chuyên theo dõi và tính toán **lượng calo tiêu hao (calories out)** mỗi ngày của cơ thể. Ứng dụng tập trung 100% vào năng lượng tiêu hao, vận hành hoàn toàn offline, bảo mật dữ liệu tuyệt đối trên thiết bị, và hỗ trợ song ngữ Tiếng Việt & Tiếng Anh.

---

## 📱 Ảnh Chụp Màn Hình (Screenshots)

| 1. Onboarding | 2. Dashboard Hôm nay | 3. Ghi Hoạt Động | 4. Biểu Đồ Lịch Sử | 5. Cài Đặt |
|:---:|:---:|:---:|:---:|:---:|
| *(Chỗ trống screenshot Onboarding)* | *(Chỗ trống screenshot Dashboard)* | *(Chỗ trống screenshot Add Activity)* | *(Chỗ trống screenshot History)* | *(Chỗ trống screenshot Settings)* |

---

## ✨ Tính Năng Nổi Bật
- **Tính toán BMR & TDEE khoa học**: Dựa trên phương trình Mifflin-St Jeor chuẩn quốc tế kết hợp 5 mức độ vận động thể chất.
- **Theo dõi calo hôm nay**: Vòng tiến độ trực quan phân tách rõ ràng phần calo BMR và calo hoạt động thực tế; thanh mục tiêu calo tùy biến.
- **Thư viện bài tập phong phú & tùy chỉnh**: Hơn 20+ hoạt động phổ biến có sẵn theo hệ số MET; cho phép người dùng tự tạo hoạt động với chỉ số MET riêng và lưu thành mẫu tái sử dụng.
- **Lịch sử & Biểu đồ đa chiều (fl_chart)**: Xem xu hướng theo Ngày / Tuần / Tháng dạng cột xếp chồng 2 màu (BMR + Vận động); chạm cột để xem danh sách bài tập chi tiết, chỉnh sửa hoặc xóa nhanh.
- **Điều hướng bảo toàn trạng thái (StatefulShellRoute)**: Duyệt qua các tab Hôm nay, Lịch sử, Hồ sơ, Cài đặt mà không làm mất vị trí cuộn hay dữ liệu tạm thời.
- **Tùy chỉnh đa dạng**: Hỗ trợ Dark Mode / Light Mode / Theo hệ thống; đổi đơn vị Metric (kg, cm) hoặc Imperial (lb, ft-in); chuyển đổi Tiếng Việt / English ngay tức thì.
- **Dữ liệu mẫu 60 ngày (Debug)**: Nút sinh dữ liệu mẫu nhanh trong môi trường phát triển để kiểm tra trực quan hiệu năng biểu đồ và tính toán.

---

## 🛠 Yêu Cầu Môi Trường (Prerequisites)
- **Flutter SDK**: `>= 3.22.0`
- **Dart SDK**: `>= 3.4.0`
- **Android**: Android SDK min 21 (Android 5.0 Lollipop) trở lên
- **iOS**: iOS 12.0 trở lên

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

### 1. Tải dependencies
```bash
flutter pub get
```

### 2. Sinh mã Drift / SQLite (khi chỉnh sửa schema CSDL)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Khởi chạy ứng dụng
```bash
# Chạy ở chế độ debug
flutter run

# Chạy trên thiết bị cụ thể
flutter run -d <device_id>
```

### 4. Build bản phát hành (Release APK)
```bash
flutter build apk --release
```

---

## 🧪 Kiểm Thử (Testing)

Dự án được bảo vệ với bộ kiểm thử tự động toàn diện:

### 1. Phân tích mã nguồn tĩnh (Linter)
Code tuân thủ quy tắc linter nghiêm ngặt (pass 100% không warning):
```bash
flutter analyze
```

### 2. Chạy toàn bộ Unit & Widget Tests
```bash
flutter test
```

### 3. Chạy Integration Test (End-to-End)
Kiểm thử luồng người dùng trọn vẹn (Onboarding -> Thêm hoạt động -> Kiểm tra Dashboard -> Xem lịch sử):
```bash
flutter test integration_test/app_flow_test.dart
```

---

## 📂 Cấu Trúc Thư Mục (Architecture)

Dự án áp dụng chặt chẽ **Clean Architecture** phân tách theo Feature:

```
lib/
├── core/
│   ├── constants/             # Hằng số toàn cục, key SharedPreferences
│   ├── router/                # GoRouter cấu hình StatefulShellRoute.indexedStack
│   ├── theme/                 # AppColors, AppTheme (Light & Dark), themeProvider
│   └── utils/                 # DateFormatter, CalorieFormatter, UnitConverter
├── features/
│   ├── activity/
│   │   ├── data/              # Drift Database (SQLite tables), Repositories Impl
│   │   ├── domain/            # ActivityEntry, ActivityType, MET Calculator
│   │   └── presentation/      # AddActivityScreen, Activity providers
│   ├── dashboard/
│   │   └── presentation/      # DashboardScreen, BurnRingCustomPainter
│   ├── history/
│   │   ├── domain/            # DayBurnRecord, HistoryPeriodSummary, HistoryAggregator
│   │   └── presentation/      # HistoryScreen, fl_chart stacked bar, drilldown modal
│   ├── profile/
│   │   ├── data/              # ProfileRepositoryImpl (SharedPreferences)
│   │   ├── domain/            # UserProfile, BMR & TDEE Calculators, Validators
│   │   └── presentation/      # OnboardingScreen, ProfileScreen, Profile providers
│   └── settings/
│       ├── domain/            # UnitSettings entity
│       └── presentation/      # SettingsScreen, UnitSettings provider
├── l10n/                      # File ngôn ngữ .arb (app_vi.arb, app_en.arb) & AppLocalizations
└── main.dart                  # Điểm khởi chạy ứng dụng (ProviderScope)
```

---

## 📐 Công Thức Tính Toán & Các Giả Định Nghiệp Vụ

### 1. Công thức tính năng lượng tiêu hao
1. **BMR (Phương trình Mifflin-St Jeor 1990)**:
   - **Nam**:
     $$\text{BMR} = 10 \times \text{Cân nặng (kg)} + 6.25 \times \text{Chiều cao (cm)} - 5 \times \text{Tuổi} + 5$$
   - **Nữ**:
     $$\text{BMR} = 10 \times \text{Cân nặng (kg)} + 6.25 \times \text{Chiều cao (cm)} - 5 \times \text{Tuổi} - 161$$
2. **TDEE (Ước tính tổng tiêu hao theo lối sống)**:
   $$\text{TDEE} = \text{BMR} \times \text{Hệ số vận động}$$
   - *Ít vận động*: 1.2
   - *Vận động nhẹ (1–3 ngày/tuần)*: 1.375
   - *Vận động vừa (3–5 ngày/tuần)*: 1.55
   - *Vận động nhiều (6–7 ngày/tuần)*: 1.725
   - *Rất nhiều (Vận động viên)*: 1.9
3. **Calo vận động thực tế (Chỉ số MET)**:
   $$\text{Calo hoạt động} = \text{MET} \times \text{Cân nặng (kg)} \times \frac{\text{Thời gian (phút)}}{60}$$
4. **Tổng calo tiêu hao hàng ngày (Không tính trùng lặp)**:
   $$\text{Tổng calo tiêu hao} = \text{BMR} + \text{Calo các hoạt động đã log}$$
   *(Lưu ý: Không lấy TDEE cộng thêm Calo hoạt động vì TDEE đã chứa hệ số vận động ước lượng).*

### 2. Các giả định nghiệp vụ quan trọng
- **BMR ngày quá khứ**: Được tính toán theo hồ sơ người dùng hiện tại (cân nặng, chiều cao, tuổi hiện tại).
- **Calo hoạt động đã lưu**: Sử dụng giá trị snapshot đã tính và lưu tại thời điểm ghi (`caloriesBurned` và `weightKgSnapshot`). Việc cập nhật cân nặng trong tương lai không làm sai lệch số liệu tập luyện trong quá khứ.
- **Quy ước lịch**: Tuần bắt đầu từ **thứ Hai** và kết thúc vào **Chủ Nhật** theo chuẩn ISO-8601.
- **Khóa điều hướng tương lai**: Ứng dụng ngăn chặn chuyển sang các ngày/tuần/tháng trong tương lai.
- **Đầy đủ ngày trong khoảng**: Mọi ngày trong khoảng chọn (tuần, tháng) đều xuất hiện; ngày không tập luyện hiển thị `activityKcal = 0` và `total = BMR`.

---

## 📚 Nguồn Dữ Liệu MET (Compendium of Physical Activities)
Chỉ số MET (Metabolic Equivalent of Task) được tham chiếu theo nghiên cứu chuẩn:
> **Ainsworth BE, et al.** *Compendium of Physical Activities: an update of activity codes and MET intensities.* Medicine and Science in Sports and Exercise, 1993, 2000, 2011 (Đại học South Carolina & Đại học Stanford).

---

## ⚠️ Giới Hạn Đã Biết (Known Limitations)
1. **Chỉ theo dõi Calories Out**: Ứng dụng được thiết kế chuyên biệt cho năng lượng tiêu hao, không theo dõi calo nạp vào từ ăn uống (Calories In) hay macro dinh dưỡng.
2. **Lưu trữ hoàn toàn cục bộ**: Ứng dụng không sử dụng tài khoản đám mây hay đồng bộ đa thiết bị; người dùng nên lưu ý khi đổi máy hoặc xóa dữ liệu ứng dụng.
3. **BMR không lưu nhật ký cân nặng hàng ngày**: BMR các ngày quá khứ hiển thị theo cân nặng hồ sơ hiện tại thay vì một đồ thị biến thiên cân nặng mỗi ngày.

---

## 🩺 Đồng Bộ Dữ Liệu Sức Khỏe (Apple Health & Health Connect)

CaloOut hỗ trợ đồng bộ dữ liệu calo vận động nền và số bước chân tự động từ **Apple Health** (trên iOS) và **Health Connect** (trên Android).

### 1. Nguyên Tắc Thiết Kế & Quyền Riêng Tư
- **Mặc định TẮT**: Tính năng hoàn toàn là tùy chọn, người dùng chủ động bật trong **Cài đặt**.
- **Chỉ ĐỌC (READ-ONLY)**: Ứng dụng chỉ xin quyền đọc `STEPS` và `ACTIVE_ENERGY_BURNED`. Tuyệt đối **không ghi đè hay sửa đổi** dữ liệu trong kho Apple Health / Health Connect.
- **Bảo mật tuyệt đối trên thiết bị**: Dữ liệu đọc về chỉ được xử lý tạm thời và lưu trữ cục bộ trên máy. Không bao giờ tải lên bất kỳ máy chủ nào.
- **Giao diện phân định minh bạch**: Calo từ Health hiển thị thành một dòng riêng biệt mang nhãn `"Apple Health"` hoặc `"Health Connect"` kèm huy hiệu `SYNC`, phân biệt rõ ràng với các bài tập nhập tay.

### 2. Thuật Toán Chống Tính Trùng (De-duplication Algorithm)
Để tránh cộng dồn hai lần lượng calo vận động (ví dụ: người dùng vừa đeo Apple Watch chạy bộ, vừa nhập tay bài chạy bộ trong CaloOut):
1. **Giả định chân lý (Ground Truth)**: Bài tập người dùng nhập tay có thời gian và chỉ số MET xác định cụ thể được ưu tiên là nguồn chính xác nhất.
2. **Khoảng thời gian bài tập nhập tay**: Mỗi hoạt động nhập tay xác định một khung giờ `[performedAt, performedAt + durationMinutes]`.
3. **Quy tắc loại trừ giao cắt (Interval Intersection)**:
   Mọi mẫu calo vận động $S$ từ Health có khoảng `[dateFrom, dateTo]` thỏa mãn:
   $$\text{dateFrom} < \text{manualEnd} \quad \text{và} \quad \text{dateTo} > \text{manualStart}$$
   sẽ bị **loại trừ hoàn toàn** khỏi tổng calo Health (`overlappingCaloriesIgnored`).
4. **Calo nền hợp lệ**: Chỉ những mẫu năng lượng phát sinh ngoài các khung giờ tập luyện thủ công (đi bộ dạo mát, lên xuống cầu thang, di chuyển thường ngày) mới được tính vào `healthActiveKcal`.
5. **Công thức tổng hợp**:
   $$\text{Total Daily Burn} = \text{BMR} + \sum \text{Manual Entries Kcal} + \text{Health Active Kcal}$$

### 3. Hướng Dẫn Cấu Hình Thủ Công Trong Xcode & Android Studio

#### A. Cấu hình Xcode (iOS)
*(Thực hiện khi mở dự án trên máy Mac)*
1. Mở file `ios/Runner.xcworkspace` trong **Xcode**.
2. Chọn target **Runner** trong danh sách Targets ở khung bên trái.
3. Chuyển sang tab **Signing & Capabilities**.
4. Nhấn nút **+ Capability** ở góc trên bên trái.
5. Tìm kiếm từ khóa **HealthKit** và nhấp đúp để thêm vào.
6. Trong mục HealthKit vừa thêm:
   - Tùy chọn *Clinical Health Records*: **Bỏ chọn** (CaloOut không yêu cầu hồ sơ bệnh án).
   - Tùy chọn *Background Delivery*: Tùy chọn nếu muốn nhận cập nhật nền.
7. Kiểm tra mục **Info**: Đảm bảo hai khóa sau đã xuất hiện (đã được cấu hình sẵn trong `Info.plist`):
   - `Privacy - Health Share Usage Description` (`NSHealthShareUsageDescription`)
   - `Privacy - Health Update Usage Description` (`NSHealthUpdateUsageDescription`)

#### B. Cấu hình Android Studio (Android)
1. Mở thư mục dự án trong **Android Studio**.
2. Kiểm tra `android/app/build.gradle`: `minSdkVersion` đã được đặt thành **26** (Health Connect bắt buộc API 26+).
3. Kiểm tra `MainActivity.kt`: Kế thừa `FlutterFragmentActivity` để hiển thị hộp thoại cấp quyền Health Connect.
4. Kiểm tra `AndroidManifest.xml`: Đã chứa đầy đủ 2 quyền `READ_STEPS`, `READ_ACTIVE_CALORIES_BURNED`, thẻ `<queries>` gói `com.google.android.apps.healthdata`, và `intent-filter` rationale.
5. **Đối với thiết bị thật Android 14+**: Health Connect được tích hợp sẵn trong hệ thống (`Cài đặt -> Bảo mật & Quyền riêng tư -> Health Connect`).
6. **Đối với thiết bị thật Android 9 - 13**: Thiết bị cần cài đặt ứng dụng **Health Connect** chính thức của Google từ Google Play Store trước khi bật tính năng.

