import 'package:caloout/core/router/app_router.dart';
import 'package:caloout/core/theme/app_theme.dart';
import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/activity/data/database/app_database.dart';
import 'package:caloout/features/activity/data/repositories/activity_log_repository_impl.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full Main User Journey: Onboarding -> Add Activity -> Dashboard Burn -> View History',
      (tester) async {
    // Clean initial storage
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final inMemoryDb = AppDatabase(NativeDatabase.memory());
    final logRepo = ActivityLogRepositoryImpl(inMemoryDb);

    addTearDown(() async {
      await inMemoryDb.close();
    });

    // Build the complete application with in-memory persistence
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDatabaseProvider.overrideWithValue(inMemoryDb),
          activityLogRepositoryProvider.overrideWithValue(logRepo),
          todayDateProvider.overrideWithValue(DateTime(2026, 10, 7)),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              title: 'CaloOut',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              locale: const Locale('vi'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // ============================================================
    // 1. ONBOARDING FLOW
    // ============================================================
    // Step 1: Gender & Age (default Male, Age 25)
    expect(find.text('Thông tin cơ bản'), findsOneWidget);
    final actionButton = find.byKey(const Key('onboarding_action_button'));
    expect(actionButton, findsOneWidget);
    await tester.tap(actionButton);
    await tester.pumpAndSettle();

    // Step 2: Height & Weight (default 170cm, 65kg)
    expect(find.text('Chiều cao & Cân nặng'), findsOneWidget);
    await tester.tap(actionButton);
    await tester.pumpAndSettle();

    // Step 3: Activity Level (default Moderate)
    expect(find.text('Mức độ vận động'), findsOneWidget);
    await tester.tap(actionButton);
    await tester.pumpAndSettle();

    // Step 4: Metrics Overview & Finish
    expect(find.text('Chỉ số phân tích'), findsOneWidget);
    await tester.tap(actionButton); // Tap 'Hoàn tất & Bắt đầu'
    await tester.pumpAndSettle();

    // ============================================================
    // 2. DASHBOARD ARRIVAL
    // ============================================================
    // Profile is now persisted, GoRouter routes to /dashboard
    expect(find.text('Tổng calo tiêu hao'), findsOneWidget);
    expect(find.text('BMR (nghỉ ngơi)'), findsOneWidget);
    expect(find.text('Hoạt động hôm nay (0)'), findsOneWidget);

    // ============================================================
    // 3. ADD ACTIVITY FLOW
    // ============================================================
    final addFab = find.byKey(const Key('dashboard_add_activity_fab'));
    expect(addFab, findsOneWidget);
    await tester.tap(addFab);
    await tester.pumpAndSettle();

    // Verify Add Activity Screen
    expect(find.text('Ghi nhận hoạt động'), findsOneWidget);

    // Switch to Custom Activity Tab
    await tester.tap(find.text('Hoạt động tùy chỉnh'));
    await tester.pumpAndSettle();

    // Enter custom workout info
    final nameField = find.byKey(const Key('custom_activity_name_field'));
    await tester.enterText(nameField, 'Bơi sải tốc độ');
    await tester.pumpAndSettle();

    final metField = find.byKey(const Key('custom_activity_met_field'));
    await tester.enterText(metField, '8.0');
    await tester.pumpAndSettle();

    final durationField = find.byKey(const Key('activity_duration_field'));
    await tester.enterText(durationField, '45');
    await tester.pumpAndSettle();

    // Save activity
    final saveBtn = find.byKey(const Key('save_activity_button'));
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();

    // ============================================================
    // 4. VERIFY DASHBOARD UPDATED
    // ============================================================
    // Dashboard should now display the newly added workout
    expect(find.text('Hoạt động hôm nay (1)'), findsOneWidget);
    expect(find.text('Bơi sải tốc độ'), findsOneWidget);

    // ============================================================
    // 5. VIEW HISTORY FLOW
    // ============================================================
    // Tap on History tab in NavigationBar
    final historyTab = find.byIcon(Icons.bar_chart_outlined);
    expect(historyTab, findsOneWidget);
    await tester.tap(historyTab);
    await tester.pumpAndSettle();

    // Verify History Screen rendered
    expect(find.text('Lịch sử tiêu hao'), findsOneWidget);
    expect(find.byKey(const Key('history_range_segmented_button')), findsOneWidget);
    expect(find.text('Tổng tiêu hao'), findsOneWidget);

    // Today's summary tile shows 1 activity logged
    expect(find.textContaining('1 hoạt động'), findsOneWidget);

    // Tap to open day detail sheet
    await tester.tap(find.textContaining('1 hoạt động'));
    await tester.pumpAndSettle();

    // Verify detail sheet shows the activity
    expect(find.text('Bơi sải tốc độ'), findsOneWidget);
  });
}
