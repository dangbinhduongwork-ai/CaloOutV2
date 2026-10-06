import 'package:caloout/core/constants/app_constants.dart';
import 'package:caloout/core/router/app_router.dart';
import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createRouterApp(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        return MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        );
      },
    ),
  );
}

void main() {
  testWidgets('Redirects to /onboarding when no profile exists', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(createRouterApp(prefs));
    // Let splash finish and route update
    await tester.pumpAndSettle();

    // Verify OnboardingScreen elements are present
    expect(find.byKey(const Key('gender_male_card')), findsOneWidget);
    expect(find.byKey(const Key('age_input_field')), findsOneWidget);
  });

  testWidgets('Redirects to /dashboard when profile already exists', (tester) async {
    SharedPreferences.setMockInitialValues({
      AppConstants.keyProfile: '''{
        "gender": "male",
        "age": 30,
        "heightCm": 175.0,
        "weightKg": 70.0,
        "activityLevel": "moderate",
        "dailyGoalKcal": 2560.0
      }''',
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(createRouterApp(prefs));
    // Let splash finish and route update
    await tester.pumpAndSettle();

    // Verify DashboardScreen elements are present
    expect(find.byKey(const Key('dashboard_goal_text')), findsOneWidget);
    expect(find.text('2,560'), findsOneWidget);
  });
}
