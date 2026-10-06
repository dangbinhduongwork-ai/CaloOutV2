import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/features/profile/presentation/onboarding_screen.dart';
import 'package:caloout/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createTestWidget(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: OnboardingScreen(),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Onboarding Step 1 displays error on invalid age and blocks next step', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(createTestWidget(prefs));
    await tester.pumpAndSettle();

    // Default age is 25, clear and type invalid age 8
    final ageField = find.byKey(const Key('age_input_field'));
    expect(ageField, findsOneWidget);

    await tester.enterText(ageField, '8');
    await tester.pumpAndSettle();

    // Should display validation error text
    expect(find.text('Age must be between 10 and 100'), findsOneWidget);

    // Tap next button
    final nextBtn = find.byKey(const Key('onboarding_action_button'));
    await tester.tap(nextBtn);
    await tester.pumpAndSettle();

    // Should still be on Step 1 (gender cards still visible)
    expect(find.byKey(const Key('gender_male_card')), findsOneWidget);
  });

  testWidgets('Onboarding Step 2 automatically converts kg to lb and back', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(createTestWidget(prefs));
    await tester.pumpAndSettle();

    // Step 1: Valid age 25 -> Next
    final nextBtn = find.byKey(const Key('onboarding_action_button'));
    await tester.tap(nextBtn);
    await tester.pumpAndSettle();

    // Now in Step 2: enter 70 kg
    final weightField = find.byKey(const Key('weight_field'));
    expect(weightField, findsOneWidget);

    await tester.enterText(weightField, '70');
    await tester.pumpAndSettle();

    // Tap 'lb' in weight toggle
    final lbSegment = find.text('lb');
    await tester.tap(lbSegment);
    await tester.pumpAndSettle();

    // Weight text should now be converted to 154.3 (70 * 2.20462...)
    final weightFieldWidget = tester.widget<TextField>(weightField);
    expect(weightFieldWidget.controller?.text, equals('154.3'));

    // Tap 'kg' in weight toggle
    final kgSegment = find.text('kg');
    await tester.tap(kgSegment);
    await tester.pumpAndSettle();

    // Weight text should convert back to 70.0 kg
    final weightFieldWidgetBack = tester.widget<TextField>(weightField);
    expect(weightFieldWidgetBack.controller?.text, equals('70.0'));
  });
}
