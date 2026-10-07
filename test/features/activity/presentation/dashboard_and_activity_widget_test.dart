import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/activity/data/database/app_database.dart';
import 'package:caloout/features/activity/data/repositories/activity_log_repository_impl.dart';
import 'package:caloout/features/activity/domain/entities/activity_entry.dart';
import 'package:caloout/features/activity/domain/entities/activity_type.dart';
import 'package:caloout/features/activity/presentation/add_activity_screen.dart';
import 'package:caloout/features/dashboard/presentation/dashboard_screen.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
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

  Widget buildTestApp(Widget home) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        activityLogRepositoryProvider.overrideWithValue(logRepo),
        profileProvider.overrideWith(() => _MockProfileNotifier(sampleProfile)),
      ],
      child: MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    );
  }

  testWidgets('AddActivityScreen updates calorie preview immediately when duration changes',
      (tester) async {
    await tester.pumpWidget(buildTestApp(const AddActivityScreen()));
    await tester.pumpAndSettle();

    // Switch to Custom Tab
    await tester.tap(find.text('Hoạt động tùy chỉnh'));
    await tester.pumpAndSettle();

    // Set custom MET to 8.0
    final metField = find.byKey(const Key('custom_activity_met_field'));
    await tester.enterText(metField, '8.0');
    await tester.pumpAndSettle();

    // Set duration to 30 minutes (70 kg * 8.0 * 30/60 = 280 kcal)
    final durationField = find.byKey(const Key('activity_duration_field'));
    await tester.enterText(durationField, '30');
    await tester.pumpAndSettle();

    final previewFinder = find.byKey(const Key('preview_calories_text'));
    expect(tester.widget<Text>(previewFinder).data, equals('280'));

    // Change duration to 60 minutes (70 kg * 8.0 * 60/60 = 560 kcal)
    await tester.enterText(durationField, '60');
    await tester.pumpAndSettle();

    expect(tester.widget<Text>(previewFinder).data, equals('560'));
  });

  testWidgets('DashboardScreen allows swiping to delete and undoing deletion',
      (tester) async {
    // Add one initial entry
    final entry = ActivityEntry(
      id: 'entry_test_undo',
      activityType: const ActivityType(
        id: 'run',
        nameKey: 'Chạy bộ nhanh',
        met: 8.0,
        category: 'cardio',
      ),
      customName: 'Chạy bộ nhanh',
      durationMinutes: 30,
      caloriesBurned: 280.0,
      weightKgSnapshot: 70.0,
      performedAt: DateTime.now(),
    );
    await logRepo.addEntry(entry);

    await tester.pumpWidget(buildTestApp(const DashboardScreen()));
    await tester.pumpAndSettle();

    // Verify activity entry is displayed
    final itemFinder = find.byKey(const Key('activity_entry_entry_test_undo'));
    expect(itemFinder, findsOneWidget);
    expect(find.text('Chạy bộ nhanh'), findsOneWidget);

    // Swipe to delete
    await tester.drag(itemFinder, const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    // Item dismissed, SnackBar shown
    expect(find.byKey(const Key('activity_entry_entry_test_undo')), findsNothing);
    final undoBtn = find.text('Hoàn tác');
    expect(undoBtn, findsOneWidget);

    // Tap Undo
    await tester.tap(undoBtn);
    await tester.pumpAndSettle();

    // Item is restored and displayed again
    expect(find.byKey(const Key('activity_entry_entry_test_undo')), findsOneWidget);
    expect(find.text('Chạy bộ nhanh'), findsOneWidget);
  });
}

class _MockProfileNotifier extends ProfileNotifier {
  _MockProfileNotifier(this._profile);
  final UserProfile _profile;

  @override
  Future<UserProfile?> build() async => _profile;
}
