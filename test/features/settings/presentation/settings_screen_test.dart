import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/activity/data/database/app_database.dart';
import 'package:caloout/features/activity/data/repositories/activity_log_repository_impl.dart';
import 'package:caloout/features/activity/presentation/providers/activity_providers.dart';
import 'package:caloout/features/profile/domain/entities/activity_level.dart';
import 'package:caloout/features/profile/domain/entities/gender.dart';
import 'package:caloout/features/profile/domain/entities/user_profile.dart';
import 'package:caloout/features/profile/presentation/providers/profile_provider.dart';
import 'package:caloout/features/settings/presentation/settings_screen.dart';
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
    age: 28,
    heightCm: 172.0,
    weightKg: 68.0,
    activityLevel: ActivityLevel.moderate,
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

  Widget buildSettingsApp({Locale? locale}) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        activityLogRepositoryProvider.overrideWithValue(logRepo),
        profileProvider.overrideWith(() => _MockProfileNotifier(sampleProfile)),
      ],
      child: MaterialApp(
        locale: locale ?? const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SettingsScreen(),
      ),
    );
  }

  testWidgets('SettingsScreen renders language selector without runtime error in Vietnamese', (tester) async {
    await tester.pumpWidget(buildSettingsApp(locale: const Locale('vi')));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byIcon(Icons.language), findsOneWidget);
  });

  testWidgets('SettingsScreen renders language selector without runtime error in English', (tester) async {
    await tester.pumpWidget(buildSettingsApp(locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byIcon(Icons.language), findsOneWidget);
  });
}

class _MockProfileNotifier extends ProfileNotifier {
  _MockProfileNotifier(this._initial);
  final UserProfile? _initial;

  @override
  Future<UserProfile?> build() async => _initial;
}
