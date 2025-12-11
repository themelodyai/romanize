import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  group('TextRomanizer', () {
    group('romanize', () {
      test('should auto-detect and romanize Korean text', () {
        const input = '안녕하세요';
        final result = TextRomanizer.romanize(input);
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      });

      test('should auto-detect and romanize Japanese text', () {
        const input = 'こんにちは';
        final result = TextRomanizer.romanize(input);
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      });

      test('should auto-detect and romanize Cyrillic text', () {
        const input = 'Привет мир';
        final result = TextRomanizer.romanize(input);
        expect(result, isNotEmpty);
        expect(result, contains('Privet'));
      });

      test('should auto-detect and romanize Chinese text', () {
        const input = '你好';
        final result = TextRomanizer.romanize(input);
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      });

      test('should auto-detect and romanize Arabic text', () {
        const input = 'أنا العربي';
        final result = TextRomanizer.romanize(input);
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      });

      test('should return empty string for empty input', () {
        const input = '';
        final result = TextRomanizer.romanize(input);
        expect(result, isEmpty);
      });

      test('should return empty string for whitespace-only input', () {
        const input = '   \n\t  ';
        final result = TextRomanizer.romanize(input);
        expect(result, isEmpty);
      });

      test('should throw ArgumentError for unsupported language', () {
        const input = 'Hello World';
        expect(
          () => TextRomanizer.romanize(input),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle mixed content correctly', () {
        const input = '안녕 Hello';
        final result = TextRomanizer.romanize(input);
        expect(result, isNotEmpty);
      });
    });

    group('forLanguage', () {
      test('should return KoreanRomanizer for "korean"', () {
        final romanizer = TextRomanizer.forLanguage('korean');
        expect(romanizer, isA<KoreanRomanizer>());
        expect(romanizer.language, equals('korean'));
      });

      test('should return KoreanRomanizer for "Korean" (case insensitive)', () {
        final romanizer = TextRomanizer.forLanguage('Korean');
        expect(romanizer, isA<KoreanRomanizer>());
      });

      test('should return KoreanRomanizer for "KOREAN" (case insensitive)', () {
        final romanizer = TextRomanizer.forLanguage('KOREAN');
        expect(romanizer, isA<KoreanRomanizer>());
      });

      test('should return JapaneseRomanizer for "japanese"', () {
        final romanizer = TextRomanizer.forLanguage('japanese');
        expect(romanizer, isA<JapaneseRomanizer>());
        expect(romanizer.language, equals('japanese'));
      });

      test('should return CyrillicRomanizer for "cyrillic"', () {
        final romanizer = TextRomanizer.forLanguage('cyrillic');
        expect(romanizer, isA<CyrillicRomanizer>());
        expect(romanizer.language, equals('cyrillic'));
      });

      test('should return ChineseRomanizer for "chinese"', () {
        final romanizer = TextRomanizer.forLanguage('chinese');
        expect(romanizer, isA<ChineseRomanizer>());
        expect(romanizer.language, equals('chinese'));
      });

      test('should return ArabicRomanizer for "arabic"', () {
        final romanizer = TextRomanizer.forLanguage('arabic');
        expect(romanizer, isA<ArabicRomanizer>());
        expect(romanizer.language, equals('arabic'));
      });

      test('should handle language with whitespace', () {
        final romanizer = TextRomanizer.forLanguage('  korean  ');
        expect(romanizer, isA<KoreanRomanizer>());
      });

      test('should throw ArgumentError for empty language', () {
        expect(
          () => TextRomanizer.forLanguage(''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for whitespace-only language', () {
        expect(
          () => TextRomanizer.forLanguage('   '),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw UnimplementedError for unsupported language', () {
        expect(
          () => TextRomanizer.forLanguage('spanish'),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('forLanguageOrNull', () {
      test('should return KoreanRomanizer for "korean"', () {
        final romanizer = TextRomanizer.forLanguageOrNull('korean');
        expect(romanizer, isNotNull);
        expect(romanizer, isA<KoreanRomanizer>());
      });

      test('should return null for null input', () {
        final romanizer = TextRomanizer.forLanguageOrNull(null);
        expect(romanizer, isNull);
      });

      test('should return null for empty string', () {
        final romanizer = TextRomanizer.forLanguageOrNull('');
        expect(romanizer, isNull);
      });

      test('should return null for whitespace-only string', () {
        final romanizer = TextRomanizer.forLanguageOrNull('   ');
        expect(romanizer, isNull);
      });

      test('should return null for unsupported language', () {
        final romanizer = TextRomanizer.forLanguageOrNull('spanish');
        expect(romanizer, isNull);
      });

      test('should handle case insensitive language names', () {
        final romanizer1 = TextRomanizer.forLanguageOrNull('KOREAN');
        final romanizer2 = TextRomanizer.forLanguageOrNull('korean');
        expect(romanizer1, isNotNull);
        expect(romanizer2, isNotNull);
        expect(romanizer1?.language, equals(romanizer2?.language));
      });

      test('should handle language with whitespace', () {
        final romanizer = TextRomanizer.forLanguageOrNull('  japanese  ');
        expect(romanizer, isNotNull);
        expect(romanizer, isA<JapaneseRomanizer>());
      });
    });

    group('supportedLanguages', () {
      test('should return list of supported languages', () {
        final languages = TextRomanizer.supportedLanguages;
        expect(languages, isNotEmpty);
        expect(languages, contains('korean'));
        expect(languages, contains('japanese'));
        expect(languages, contains('chinese'));
        expect(languages, contains('cyrillic'));
        expect(languages, contains('arabic'));
      });

      test('should return immutable list', () {
        final languages = TextRomanizer.supportedLanguages;
        expect(languages, isA<List<String>>());
      });
    });
  });
}
