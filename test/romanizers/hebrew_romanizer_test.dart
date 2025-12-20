import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await TextRomanizer.ensureInitialized();
  });

  group('HebrewRomanizer', () {
    const romanizer = HebrewRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language, equals('hebrew'));
    });

    group('isValid', () {
      test('should return true for Hebrew text', () {
        expect(romanizer.isValid('שָׁלוֹם'), isTrue); // Shalom
        expect(romanizer.isValid('עִבְרִית'), isTrue); // Ivrit
        expect(romanizer.isValid('אני'), isTrue); // Ani (unpointed)
      });

      test('should return false for non-Hebrew text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse);
        expect(romanizer.isValid('مرحبا'), isFalse); // Arabic
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Hebrew and other text', () {
        expect(romanizer.isValid('שָׁלוֹם Hello'), isTrue);
        expect(romanizer.isValid('Hello שָׁלוֹם'), isTrue);
      });

      test('should return false for empty string', () {
        expect(romanizer.isValid(''), isFalse);
      });

      test('should return false for whitespace-only string', () {
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize Hebrew text', () {
        // Shalom: Shin, Qamats, Lamed, Holam Male, Final Mem
        final result = romanizer.romanize('שָׁלוֹם');
        expect(result, isNotEmpty);
        expect(result, isA<String>());
        expect(result, equals('shālōm'));
      });

      test('should romanize simple unpointed text', () {
        // Ani: Alef, Nun, Yod
        final result = romanizer.romanize('אני');
        expect(result, equals('ʾny'));
      });

      test('should handle mixed content', () {
        final result = romanizer.romanize('שָׁלוֹם Hello');
        expect(result, equals('shālōm Hello'));
      });

      test('should handle empty string', () {
        final result = romanizer.romanize('');
        expect(result, isEmpty);
        expect(result, equals(''));
      });

      test('should preserve non-Hebrew characters', () {
        final result = romanizer.romanize('שָׁלוֹם Hello 123');
        expect(result, contains('Hello'));
        expect(result, contains('123'));
        expect(result, equals('shālōm Hello 123'));
      });

      test('should handle longer Hebrew text', () {
        // Bereshit bara Elohim (In the beginning God created)
        // בְּרֵאשִׁית בָּרָא אֱלֹהִים
        // Note: Our romanizer is character-based and might be verbose with Alefs/Yods
        const hebrewText = 'בְּרֵאשִׁית בָּרָא אֱלֹהִים';
        final result = romanizer.romanize(hebrewText);
        expect(result, isNotEmpty);

        // Expected derivation based on map:
        // בְּרֵאשִׁית -> b e r ē ʾ sh i y t -> berēʾshiyt
        // בָּרָא -> b ā r ā ʾ -> bārāʾ
        // אֱלֹהִים -> ʾ e l ō h i y m -> ʾelōhiym
        expect(result, equals('berēʾshiyt bārāʾ ʾelōhiym'));
      });
    });
  });
}
