import 'package:caloout/core/theme/theme_provider.dart';
import 'package:caloout/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('CaloOutApp basic smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const CaloOutApp(),
      ),
    );

    await tester.pump();
    expect(find.byType(CaloOutApp), findsOneWidget);
  });
}
