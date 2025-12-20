import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await TextRomanizer.ensureInitialized();
  });

  group('JapaneseRomanizer', () {
    final romanizer = JapaneseRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language, equals('japanese'));
    });

    group('isValid', () {
      test(
        'should return true for Japanese text (Hiragana/Katakana/Kanji)',
        () {
          expect(romanizer.isValid('こんにちは'), isTrue); // Hiragana
          expect(romanizer.isValid('コンピュータ'), isTrue); // Katakana
          expect(romanizer.isValid('東京'), isTrue); // Kanji
          expect(romanizer.isValid('私'), isTrue); // Kanji
        },
      );

      test('should return false for non-Japanese text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('안녕하세요'), isFalse); // Korean
        expect(romanizer.isValid('Привет'), isFalse); // Cyrillic
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Japanese and other text', () {
        expect(romanizer.isValid('こんにちは Hello'), isTrue);
        expect(romanizer.isValid('Hello 東京'), isTrue);
      });

      test('should return false for empty or whitespace-only strings', () {
        expect(romanizer.isValid(''), isFalse);
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize basic Hiragana (Hepburn)', () {
        expect(romanizer.romanize('し'), equals('shi'));
        expect(romanizer.romanize('ち'), equals('chi'));
        expect(romanizer.romanize('つ'), equals('tsu'));
        expect(romanizer.romanize('ふ'), equals('fu'));
        expect(romanizer.romanize('じ'), equals('ji'));
      });

      test('should romanize basic Katakana', () {
        expect(romanizer.romanize('サ'), equals('sa'));
        expect(romanizer.romanize('シ'), equals('shi'));
        expect(romanizer.romanize('ツ'), equals('tsu'));
        expect(romanizer.romanize('ン'), equals('n'));
      });

      test('should handle dakuten (voiced marks)', () {
        expect(romanizer.romanize('だ'), equals('da'));
        expect(romanizer.romanize('が'), equals('ga'));
        expect(romanizer.romanize('ざ'), equals('za'));
        expect(romanizer.romanize('ば'), equals('ba'));
      });

      test('should handle handakuten (semi-voiced marks)', () {
        expect(romanizer.romanize('ぱ'), equals('pa'));
        expect(romanizer.romanize('ぴ'), equals('pi'));
      });

      test('should handle sokuon (small tsu / gemination)', () {
        expect(romanizer.romanize('さっか'), equals('sakka'));
        expect(romanizer.romanize('きっぷ'), equals('kippu'));
        expect(romanizer.romanize('ずっと'), equals('zutto'));
      });

      test('should handle yoon (contracted sounds)', () {
        expect(romanizer.romanize('きゃ'), equals('kya'));
        expect(romanizer.romanize('しゅ'), equals('shiyu'));
        expect(romanizer.romanize('ちょ'), equals('cho'));
        expect(romanizer.romanize('にゃ'), equals('nya'));
        expect(romanizer.romanize('ひょ'), equals('hyo'));
      });

      test('should romanize Kanji to Hiragana/Romaji', () {
        final result = romanizer.romanize('日本');
        // Accept either 'nihon' or 'nippon'
        expect(result, anyOf(equals('nihon'), equals('nippon')));

        expect(
          romanizer.romanize('東京'),
          anyOf(equals('tokyo'), equals('tōkyō'), equals('toukyou')),
        );
      });

      test('should handle greetings and phrases', () {
        final result = romanizer.romanize('こんにちは');
        expect(result, anyOf(equals('konnichiwa'), equals('konnichiha')));
      });

      test('should preserve non-Japanese characters', () {
        final result = romanizer.romanize('Hello 東京 123');
        expect(result, contains('Hello'));
        expect(result, contains('123'));
        expect(result, anyOf(contains('tokyo'), contains('toukyou')));
      });
    });
  });
}
