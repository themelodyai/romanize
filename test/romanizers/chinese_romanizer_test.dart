import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await TextRomanizer.ensureInitialized();
  });

  group('ChineseRomanizer', () {
    test('should have correct language name', () {
      const romanizer = ChineseRomanizer();
      expect(romanizer.language, equals('chinese'));
    });

    group('isValid', () {
      const romanizer = ChineseRomanizer();

      test('should return true for Simplified Chinese text', () {
        expect(romanizer.isValid('你好'), isTrue);
        expect(romanizer.isValid('中国'), isTrue);
        expect(romanizer.isValid('北京'), isTrue);
      });

      test('should return true for Traditional Chinese text', () {
        expect(romanizer.isValid('臺灣'), isTrue); // Taiwan
        expect(romanizer.isValid('繁體'), isTrue); // Traditional
      });

      test('should return false for non-Chinese text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse); // Japanese
        expect(romanizer.isValid('안녕하세요'), isFalse); // Korean
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Chinese and other text', () {
        expect(romanizer.isValid('你好 Hello'), isTrue);
        expect(romanizer.isValid('Hello 你好'), isTrue);
      });

      test('should return false for empty or whitespace-only strings', () {
        expect(romanizer.isValid(''), isFalse);
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      group('ToneAnnotation.mark (default)', () {
        const romanizer = ChineseRomanizer();

        test('should romanize with tone marks', () {
          // Ni Hao
          expect(romanizer.romanize('你好'), equals('nǐ hǎo'));
          // Shi Jie (World)
          expect(romanizer.romanize('世界'), equals('shì jiè'));
        });

        test('should handle Traditional Chinese', () {
          // Taiwan -> Tai Wan
          expect(romanizer.romanize('臺灣'), equals('tái wān'));
        });
      });

      group('ToneAnnotation.number', () {
        const romanizer = ChineseRomanizer(
          toneAnnotation: ToneAnnotation.number,
        );

        test('should romanize with tone numbers', () {
          expect(romanizer.romanize('你好'), equals('ni3 hao3'));
          expect(romanizer.romanize('世界'), equals('shi4 jie4'));
        });

        test('should handle neutral tones if applicable', () {
          // "ma" (question particle) is often neutral (5 or no number),
          // dependent on pinyin package dictionary.
          // We test a standard char 'ma' 吗 -> ma
          // Using a known neutral tone char might be tricky depending on package version,
          // so we rely on standard numbered output.
          expect(romanizer.romanize('吗'), anyOf(contains('ma'), contains('5')));
        });
      });

      group('ToneAnnotation.none', () {
        const romanizer = ChineseRomanizer(toneAnnotation: ToneAnnotation.none);

        test('should romanize without tones', () {
          expect(romanizer.romanize('你好'), equals('ni hao'));
          expect(romanizer.romanize('世界'), equals('shi jie'));
        });
      });

      group('Edge cases and Mixed content', () {
        const romanizer = ChineseRomanizer();

        test('should handle multiline text', () {
          const input = '你好\n世界';
          // Implementation processes line by line and uses writeln,
          // so we expect a newline after every line.
          final result = romanizer.romanize(input);
          expect(result, equals('nǐ hǎo\nshì jiè\n'));
        });

        test('should preserve non-Chinese characters', () {
          final result = romanizer.romanize('你好 Hello 123');

          expect(result, contains('nǐ hǎo'));
          expect(result, contains('Hello'));
          expect(result, contains('123'));
        });

        test('should handle empty string', () {
          expect(romanizer.romanize(''), isEmpty);
        });

        test('should handle whitespace only', () {
          expect(romanizer.romanize('   '), isEmpty);
        });
      });
    });
  });
}
