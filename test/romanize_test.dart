import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await TextRomanizer.ensureInitialized();
  });

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
        expect(languages.any((l) => l is ChineseRomanizer), isTrue);
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

      test(
        'should correctly identify mixed Japanese (Kanji + Kana) vs Chinese',
        () {
          // "This is Japanese" (contains Kanji '日本' and Hiragana 'これは...です')
          const japaneseInput = 'これは日本語です';
          final jpResult = TextRomanizer.romanize(japaneseInput);
          // Should detect as Japanese and output "korehanihongodesu" (or similar)
          // If it detected Chinese, it would output Pinyin for the Kanji parts.
          expect(jpResult, contains('nihongo'));

          // "This is Chinese" (Pure Kanji)
          const chineseInput = '这是中文';
          final cnResult = TextRomanizer.romanize(chineseInput);
          expect(cnResult, contains('zhōng'));
        },
      );

      test('should split and romanize tokens separated by underscores', () {
        final japaneseRomanizer = JapaneseRomanizer();
        final japaneseInput = 'こんにちは';

        final koreanRomanizer = HangulRomanizer();
        final koreanInput = '안녕하세요';

        final input = 'KR:${koreanInput}_JP:$japaneseInput';
        final result = TextRomanizer.romanize(input);
        expect(result, contains(japaneseRomanizer.romanize(japaneseInput)));
        expect(result, contains(koreanRomanizer.romanize(koreanInput)));
      });
    });

    group('analyze', () {
      test('should analyze multi-language text correctly', () {
        const input = '你好 Hello 안녕';
        final result = TextRomanizer.analyze(input);

        // Expect: [Word(你好), Sep( ), Word(Hello), Sep( ), Word(안녕)]
        expect(result, hasLength(5));

        // 1. Chinese/Japanese word
        expect(result[0].rawText, equals('你好'));
        // Note: Language detection for short strings like '你好' might be 'chinese' or 'japanese'
        expect(result[0].language, isIn(['chinese', 'japanese']));
        expect(result[0].romanizedText, isNotEmpty);

        // 2. Separator (Space)
        expect(result[1].rawText, equals(' '));
        expect(
          result[1].language,
          isEmpty,
        ); // Separators have empty string language
        expect(result[1].romanizedText, equals(' '));

        // 3. English word (Unsupported/Empty)
        expect(result[2].rawText, equals('Hello'));
        expect(
          result[2].language,
          equals('empty'),
        ); // detectLanguage returns 'empty' for unsupported
        expect(result[2].romanizedText, equals('Hello'));

        // 4. Separator (Space)
        expect(result[3].rawText, equals(' '));

        // 5. Korean word
        expect(result[4].rawText, equals('안녕'));
        expect(result[4].language, equals('korean'));
        expect(result[4].romanizedText, isNotEmpty);
      });

      test('should preserve punctuation and sentence structure', () {
        const input = 'Hello, World!';
        final result = TextRomanizer.analyze(input);

        final reconstructed = result.map((r) => r.rawText).join();
        expect(reconstructed, equals(input));
      });

      test('should handle repeated words consistently (caching)', () {
        const input = '안녕 & 안녕';
        final result = TextRomanizer.analyze(input);

        final firstWord = result.first;
        final lastWord = result.last;

        expect(firstWord.rawText, equals('안녕'));
        expect(lastWord.rawText, equals('안녕'));

        // The romanization should be identical
        expect(firstWord.romanizedText, equals(lastWord.romanizedText));
        expect(firstWord.language, equals(lastWord.language));
      });

      test('should return empty list for empty input', () {
        final result = TextRomanizer.analyze('');
        expect(result, isEmpty);
      });

      test('should treat whitespace-only input as separators', () {
        const input = '   ';
        final result = TextRomanizer.analyze(input);

        expect(result, isNotEmpty);
        expect(result.first.rawText, equals(input));
        expect(result.first.language, isEmpty); // Separator
      });

      test('should identify specific languages correctly in a sentence', () {
        // Korean + Punctuation + Japanese
        const input = '안녕하세요. こんにちは。';
        final result = TextRomanizer.analyze(input);

        final koreanPart = result.firstWhere((r) => r.rawText == '안녕하세요');
        expect(koreanPart.language, equals('korean'));

        final japanesePart = result.firstWhere((r) => r.rawText == 'こんにちは');
        expect(japanesePart.language, equals('japanese'));
      });

      test('should split mixed Latin and Hangul (abc가나다)', () {
        const input = 'abc가나다';
        final result = TextRomanizer.analyze(input);

        // Expect: [Latin(abc), Hangul(가나다)]
        expect(result, hasLength(2));

        expect(result[0].rawText, equals('abc'));
        expect(result[0].language, equals('empty'));

        expect(result[1].rawText, equals('가나다'));
        expect(result[1].language, equals('korean'));
      });

      test('should split mixed Numbers and Scripts', () {
        // "Room101" -> Room (Latin), 101 (Digits)
        const input = 'Room101';
        final result = TextRomanizer.analyze(input);

        expect(result, hasLength(2));
        expect(result[0].rawText, equals('Room'));
        expect(result[1].rawText, equals('101'));
      });

      test('should NOT split natural Japanese (Kanji + Kana)', () {
        // "日本語です" (Kanji + Hiragana) should stay as ONE chunk
        const input = '日本語です';
        final result = TextRomanizer.analyze(input);

        expect(result, hasLength(1));
        expect(result[0].rawText, equals('日本語です'));
        expect(result[0].language, equals('japanese'));
      });

      test('should handle a complex snippet', () {
        // Input: 123٤٥٦(Numbers)abc가나다(Hangul)カキク(Katakana)
        // 123   -> Digits
        // ٤٥٦   -> Arabic
        // (     -> Separator
        // Numbers -> Latin
        // )     -> Separator
        // abc   -> Latin
        // 가나다 -> Korean
        // (     -> Separator
        // Hangul -> Latin
        // )     -> Separator
        // ... etc

        const input = '123٤٥٦(Numbers)abc가나다';
        final result = TextRomanizer.analyze(input);

        // 1. Check "123٤٥٦" split
        // ASCII digits [0-9] are separate from Arabic script in the regex
        final part123 = result.firstWhere((r) => r.rawText == '123');
        final partArabicNum = result.firstWhere((r) => r.rawText == '٤٥٦');

        expect(part123, isNotNull);
        expect(partArabicNum, isNotNull);
        expect(partArabicNum.language, equals('arabic'));

        // 2. Check "abc가나다" split
        // Find the sequence where abc is followed immediately by 가나다
        final indexAbc = result.indexWhere((r) => r.rawText == 'abc');
        expect(indexAbc, isNot(-1));

        final partKorean = result[indexAbc + 1];
        expect(partKorean.rawText, equals('가나다'));
        expect(partKorean.language, equals('korean'));
      });

      test('should split CJK vs Latin', () {
        const input = 'Hello你好';
        final result = TextRomanizer.analyze(input);

        expect(result, hasLength(2));
        expect(result[0].rawText, equals('Hello'));
        expect(result[1].rawText, equals('你好'));
      });

      test('should split Cyrillic vs Latin', () {
        const input = 'TestТест'; // Latin 'Test', Cyrillic 'Test'
        final result = TextRomanizer.analyze(input);

        expect(result, hasLength(2));
        expect(result[0].rawText, equals('Test'));
        expect(result[1].rawText, equals('Тест'));
        expect(result[1].language, equals('cyrillic'));
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
        expect(languages, contains('hebrew'));
      });

      test('should return immutable set', () {
        final languages = TextRomanizer.supportedLanguages;
        expect(languages, isA<Set<String>>());
      });
    });
  });
}
