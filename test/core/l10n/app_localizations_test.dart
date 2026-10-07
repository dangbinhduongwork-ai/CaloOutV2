import 'package:caloout/l10n/app_localizations.dart';
import 'package:caloout/l10n/app_localizations_en.dart';
import 'package:caloout/l10n/app_localizations_vi.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizations language keys regression test', () {
    test('English localizations contain all language selector keys', () {
      final l10nEn = AppLocalizationsEn();

      expect(l10nEn.languageSystem, isNotEmpty);
      expect(l10nEn.languageVietnamese, isNotEmpty);
      expect(l10nEn.languageEnglish, equals('English'));
    });

    test('Vietnamese localizations contain all language selector keys', () {
      final l10nVi = AppLocalizationsVi();

      expect(l10nVi.languageSystem, isNotEmpty);
      expect(l10nVi.languageVietnamese, isNotEmpty);
      expect(l10nVi.languageEnglish, isNotEmpty);
    });

    test('lookupAppLocalizations resolves languageEnglish for en and vi', () {
      final en = lookupAppLocalizations(const Locale('en'));
      expect(en.languageEnglish, equals('English'));

      final vi = lookupAppLocalizations(const Locale('vi'));
      expect(vi.languageEnglish, isNotEmpty);
    });
  });
}
