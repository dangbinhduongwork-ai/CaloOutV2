import 'package:caloout/features/activity/domain/parsers/activity_catalog_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityCatalogParser', () {
    test('parses valid JSON string with root map correctly', () {
      const validJson = '''
      {
        "source": "2024 Compendium of Physical Activities",
        "activities": [
          {
            "id": "walking_moderate",
            "nameKey": "walking_moderate",
            "category": "cardio",
            "met": 3.5,
            "isCustom": false
          },
          {
            "id": "running_fast",
            "nameKey": "running_fast",
            "category": "cardio",
            "met": 9.8
          }
        ]
      }
      ''';

      final result = ActivityCatalogParser.parseJson(validJson);
      expect(result.length, equals(2));

      expect(result[0].id, equals('walking_moderate'));
      expect(result[0].nameKey, equals('walking_moderate'));
      expect(result[0].category, equals('cardio'));
      expect(result[0].met, closeTo(3.5, 0.001));
      expect(result[0].isCustom, isFalse);

      expect(result[1].id, equals('running_fast'));
      expect(result[1].met, closeTo(9.8, 0.001));
    });

    test('parses numeric string MET if present', () {
      const jsonWithNumericString = '''
      {
        "activities": [
          {
            "id": "swimming",
            "nameKey": "swimming",
            "category": "cardio",
            "met": "5.8"
          }
        ]
      }
      ''';

      final result = ActivityCatalogParser.parseJson(jsonWithNumericString);
      expect(result.length, equals(1));
      expect(result[0].met, closeTo(5.8, 0.001));
    });

    test('throws FormatException when required fields are missing', () {
      // Missing 'id'
      const missingId = '''
      {
        "activities": [
          {
            "category": "cardio",
            "met": 5.0
          }
        ]
      }
      ''';
      expect(() => ActivityCatalogParser.parseJson(missingId), throwsFormatException);

      // Missing 'category'
      const missingCategory = '''
      {
        "activities": [
          {
            "id": "test_act",
            "met": 5.0
          }
        ]
      }
      ''';
      expect(() => ActivityCatalogParser.parseJson(missingCategory), throwsFormatException);

      // Missing 'met'
      const missingMet = '''
      {
        "activities": [
          {
            "id": "test_act",
            "category": "cardio"
          }
        ]
      }
      ''';
      expect(() => ActivityCatalogParser.parseJson(missingMet), throwsFormatException);
    });

    test('throws FormatException when MET is of invalid type', () {
      // MET is a boolean
      const booleanMet = '''
      {
        "activities": [
          {
            "id": "yoga",
            "category": "flexibility",
            "met": true
          }
        ]
      }
      ''';
      expect(() => ActivityCatalogParser.parseJson(booleanMet), throwsFormatException);

      // MET is an unparseable string
      const invalidStringMet = '''
      {
        "activities": [
          {
            "id": "yoga",
            "category": "flexibility",
            "met": "very_high"
          }
        ]
      }
      ''';
      expect(() => ActivityCatalogParser.parseJson(invalidStringMet), throwsFormatException);
    });

    test('throws FormatException on empty or malformed JSON string', () {
      expect(() => ActivityCatalogParser.parseJson(''), throwsFormatException);
      expect(() => ActivityCatalogParser.parseJson('   '), throwsFormatException);
      expect(() => ActivityCatalogParser.parseJson('{not-valid-json}'), throwsFormatException);
    });
  });
}
