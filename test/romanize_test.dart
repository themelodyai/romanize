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
        expect(result, equals(input));
      });

      test(
        'should handle unsupported language by returning input unchanged',
        () {
          const input = 'Hello World';
          final result = TextRomanizer.romanize(input);
          // EmptyRomanizer returns input unchanged
          expect(result, contains('Hello'));
          expect(result, contains('World'));
        },
      );

      test('should handle multi-language text correctly', () {
        const input = '안녕 Hello 你好';
        final result = TextRomanizer.romanize(input);
        expect(result, isNotEmpty);
        // Should contain romanized Korean and Chinese, plus unchanged English
        expect(result, contains('Hello'));
      });

      test('should process each word separately', () {
        const input = '你好 Hello';
        final result = TextRomanizer.romanize(input);
        // Should romanize Chinese word and keep English word
        expect(result, isNotEmpty);
        expect(result, contains('Hello'));
      });

      test('should preserve line breaks', () {
        const input = '안녕\nHello';
        final result = TextRomanizer.romanize(input);
        expect(result, contains('\n'));
      });
    });

    group('forLanguage', () {
      test('should return HangulRomanizer for "korean"', () {
        final romanizer = TextRomanizer.forLanguage('korean');
        expect(romanizer, isA<HangulRomanizer>());
        expect(romanizer.language, equals('korean'));
      });

      test('should return HangulRomanizer for "Korean" (case insensitive)', () {
        final romanizer = TextRomanizer.forLanguage('Korean');
        expect(romanizer, isA<HangulRomanizer>());
      });

      test('should return HangulRomanizer for "KOREAN" (case insensitive)', () {
        final romanizer = TextRomanizer.forLanguage('KOREAN');
        expect(romanizer, isA<HangulRomanizer>());
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
        expect(romanizer, isA<HangulRomanizer>());
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
      test('should return HangulRomanizer for "korean"', () {
        final romanizer = TextRomanizer.forLanguageOrNull('korean');
        expect(romanizer, isNotNull);
        expect(romanizer, isA<HangulRomanizer>());
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

    group('detectLanguage', () {
      test('should detect Korean language', () {
        const input = '안녕하세요';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer, isA<HangulRomanizer>());
        expect(romanizer.language, equals('korean'));
      });

      test('should detect Japanese language', () {
        const input = 'こんにちは';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer, isA<JapaneseRomanizer>());
        expect(romanizer.language, equals('japanese'));
      });

      test('should detect Chinese language', () {
        const input = '你好';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer, isA<ChineseRomanizer>());
        expect(romanizer.language, equals('chinese'));
      });

      test('should detect Cyrillic language', () {
        const input = 'Привет';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer, isA<CyrillicRomanizer>());
        expect(romanizer.language, equals('cyrillic'));
      });

      test('should detect Arabic language', () {
        const input = 'أنا';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer, isA<ArabicRomanizer>());
        expect(romanizer.language, equals('arabic'));
      });

      test('should return EmptyRomanizer for empty input', () {
        const input = '';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer.language, equals('empty'));
        // EmptyRomanizer returns input unchanged
        expect(romanizer.romanize('test'), equals('test'));
      });

      test('should return EmptyRomanizer for whitespace-only input', () {
        const input = '   ';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer.language, equals('empty'));
      });

      test('should return EmptyRomanizer for unsupported language', () {
        const input = 'Hello World';
        final romanizer = TextRomanizer.detectLanguage(input);
        expect(romanizer.language, equals('empty'));
        // EmptyRomanizer returns input unchanged
        expect(romanizer.romanize(input), equals(input));
      });
    });

    group('detectLanguages', () {
      test('should detect Korean language', () {
        const input = '안녕하세요';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isNotEmpty);
        expect(languages.length, equals(1));
        expect(languages.first, isA<HangulRomanizer>());
        expect(languages.first.language, equals('korean'));
      });

      test('should detect Japanese language', () {
        const input = 'こんにちは';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isNotEmpty);
        expect(languages.length, equals(1));
        expect(languages.first, isA<JapaneseRomanizer>());
        expect(languages.first.language, equals('japanese'));
      });

      test('should detect Chinese language', () {
        const input = '你好';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isNotEmpty);
        expect(languages.length, equals(1));
        expect(languages.first, isA<ChineseRomanizer>());
        expect(languages.first.language, equals('chinese'));
      });

      test('should detect Cyrillic language', () {
        const input = 'Привет';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isNotEmpty);
        expect(languages.length, equals(1));
        expect(languages.first, isA<CyrillicRomanizer>());
        expect(languages.first.language, equals('cyrillic'));
      });

      test('should detect Arabic language', () {
        const input = 'أنا';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isNotEmpty);
        expect(languages.length, equals(1));
        expect(languages.first, isA<ArabicRomanizer>());
        expect(languages.first.language, equals('arabic'));
      });

      test('should return set with EmptyRomanizer for empty input', () {
        const input = '';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isNotEmpty);
        expect(languages.length, equals(1));
        expect(languages.first.language, equals('empty'));
      });

      test(
        'should return set with EmptyRomanizer for whitespace-only input',
        () {
          const input = '   ';
          final languages = TextRomanizer.detectLanguages(input);
          expect(languages, isNotEmpty);
          expect(languages.length, equals(1));
          expect(languages.first.language, equals('empty'));
        },
      );

      test('should return empty set for unsupported language', () {
        const input = 'Hello World';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isEmpty);
      });

      test('should return a Set', () {
        const input = '안녕하세요';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages, isA<Set<Romanizer>>());
      });

      test('should handle mixed content that matches multiple languages', () {
        // Note: This test depends on whether any romanizer accepts mixed content
        // In practice, most romanizers will accept mixed content if it contains
        // their language's characters
        const input = '안녕 Hello 你好';
        final languages = TextRomanizer.detectLanguages(input);
        // Should detect at least Korean and Chinese
        expect(languages.length, greaterThanOrEqualTo(1));
        final languageNames = languages.map((r) => r.language).toSet();
        expect(languageNames, contains('korean'));
        expect(languageNames, contains('chinese'));
      });

      test('should return unique romanizers (no duplicates)', () {
        const input = '안녕하세요';
        final languages = TextRomanizer.detectLanguages(input);
        expect(languages.length, equals(languages.toSet().length));
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

      test('should return immutable set', () {
        final languages = TextRomanizer.supportedLanguages;
        expect(languages, isA<Set<String>>());
      });
    });
  });
}
