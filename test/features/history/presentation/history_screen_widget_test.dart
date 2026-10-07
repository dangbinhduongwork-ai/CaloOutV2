import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/activity/data/database/app_database.dart';
import 'package:caloout/features/activity/data/repositories/activity_log_repository_impl.dart';
import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/features/history/domain/entities/history_range_type.dart';
import 'package:caloout/features/history/presentation/history_screen.dart';
import 'package:caloout/features/history/presentation/providers/history_providers.dart';
import 'package:caloout/features/profile/domain/entities/activity_level.dart';
import 'package:caloout/features/profile/domain/entities/gender.dart';
import 'package:caloout/features/profile/domain/entities/user_profile.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late AppDatabase db;
  late ActivityLogRepositoryImpl logRepo;

  const sampleProfile = UserProfile(
    gender: Gender.male,
    age: 30,
    heightCm: 175.0,
    weightKg: 70.0,
    activityLevel: ActivityLevel.moderate,
    dailyGoalKcal: 2500.0,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    logRepo = ActivityLogRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  Widget buildTestApp() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        activityLogRepositoryProvider.overrideWithValue(logRepo),
        profileProvider.overrideWith(() => _MockProfileNotifier(sampleProfile)),
        todayDateProvider.overrideWithValue(DateTime(2026, 10, 7)),
        historyAnchorDateProvider.overrideWith((ref) => DateTime(2026, 10, 7)),
        historyRangeTypeProvider.overrideWith((ref) => HistoryRangeType.week),
      ],
      child: const MaterialApp(
        locale: Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HistoryScreen(),
      ),
    );
  }

  testWidgets('HistoryScreen renders week view, empty state, and handles future navigation lock',
      (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // 1. Verify SegmentedButton options exist
    expect(find.byKey(const Key('history_range_segmented_button')), findsOneWidget);
    expect(find.text('Ngày'), findsOneWidget);
    expect(find.text('Tuần'), findsOneWidget);
    expect(find.text('Tháng'), findsOneWidget);

    // 2. Verify empty state when no activities exist:
    // Still shows BMR summary and cards without crashing
    expect(find.text('Tổng tiêu hao'), findsOneWidget);
    expect(find.text('Trung bình/ngày'), findsOneWidget);
    expect(find.text('Ngày cao nhất'), findsOneWidget);
    expect(find.text('Chỉ có BMR (nghỉ ngơi)'), findsWidgets);

    // 3. Next button must be disabled because anchor is current week
    final nextBtnFinder = find.byKey(const Key('history_next_button'));
    expect(nextBtnFinder, findsOneWidget);
    IconButton nextBtn = tester.widget<IconButton>(nextBtnFinder);
    expect(nextBtn.onPressed, isNull);

    // 4. Tap Previous button to move back one week
    final prevBtnFinder = find.byKey(const Key('history_prev_button'));
    await tester.tap(prevBtnFinder);
    await tester.pumpAndSettle();

    // Next button should now be enabled
    nextBtn = tester.widget<IconButton>(nextBtnFinder);
    expect(nextBtn.onPressed, isNotNull);

    // 5. Tap Next button to return to the current week
    await tester.tap(nextBtnFinder);
    await tester.pumpAndSettle();

    // Next button should be locked again
    nextBtn = tester.widget<IconButton>(nextBtnFinder);
    expect(nextBtn.onPressed, isNull);
  });

  testWidgets('HistoryScreen toggles between Day, Week, and Month segments',
      (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Switch to Day view
    await tester.tap(find.text('Ngày'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('history_period_label')), findsOneWidget);

    // Verify next button is disabled for current day
    IconButton nextBtn = tester.widget<IconButton>(find.byKey(const Key('history_next_button')));
    expect(nextBtn.onPressed, isNull);

    // Switch to Month view
    await tester.tap(find.text('Tháng'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('history_period_label')), findsOneWidget);

    // Switch back to Week view
    await tester.tap(find.text('Tuần'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('history_period_label')), findsOneWidget);
  });

  testWidgets('Tapping a day tile opens detail bottom sheet and displays logged activities',
      (tester) async {
    // Add one sample activity on 2026-10-07
    await logRepo.addEntry(
      ActivityEntry(
        id: 'hist_test_1',
        activityType: const ActivityType(
          id: 'running',
          nameKey: 'Chạy bộ',
          met: 8.0,
          category: 'cardio',
        ),
        durationMinutes: 45,
        caloriesBurned: 350.0,
        weightKgSnapshot: 70.0,
        performedAt: DateTime(2026, 10, 7, 10, 30),
      ),
    );

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Verify that the day tile for today shows the logged activity summary
    expect(find.text('1 hoạt động • 45 phút'), findsOneWidget);

    // Tap on the day card tile to open detail bottom sheet
    await tester.tap(find.text('1 hoạt động • 45 phút'));
    await tester.pumpAndSettle();

    // Bottom sheet is now visible
    expect(find.text('Các hoạt động đã ghi (1)'), findsOneWidget);
    expect(find.text('Chạy bộ'), findsOneWidget);
    expect(find.text('+350 kcal'), findsOneWidget);
  });
}

class _MockProfileNotifier extends AsyncNotifier<UserProfile?> {
  _MockProfileNotifier(this._profile);
  final UserProfile _profile;

  @override
  Future<UserProfile?> build() async => _profile;
}
