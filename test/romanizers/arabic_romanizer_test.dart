import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await TextRomanizer.ensureInitialized();
  });

  group('ArabicRomanizer', () {
    test('should have correct language name', () {
      const romanizer = ArabicRomanizer();
      expect(romanizer.language, equals('arabic'));
    });

    group('isValid', () {
      const romanizer = ArabicRomanizer();

      test('should return true for Arabic text', () {
        expect(romanizer.isValid('أنا'), isTrue);
        expect(romanizer.isValid('العربي'), isTrue);
        expect(romanizer.isValid('مرحبا'), isTrue);
      });

      test('should return true for text with diacritics', () {
        expect(romanizer.isValid('بُرج'), isTrue); // Burj
        expect(romanizer.isValid('كِتَاب'), isTrue); // Kitab
      });

      test('should return false for non-Arabic text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('123'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse);
      });

      test('should return true for mixed Arabic and other text', () {
        expect(romanizer.isValid('أنا Hello'), isTrue);
        expect(romanizer.isValid('Hello أنا'), isTrue);
      });

      test('should return false for empty or whitespace-only strings', () {
        expect(romanizer.isValid(''), isFalse);
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      group('ALA-LC (Default)', () {
        const romanizer = ArabicRomanizer(system: ArabicSystem.alaLc);

        test('should romanize basic letters', () {
          expect(romanizer.romanize('كتاب'), equals('ktāb')); // k-t-ā-b
          expect(romanizer.romanize('شمس'), equals('shms')); // sh-m-s
        });

        test('should handle diacritics (vowels)', () {
          // Fatha (a), Damma (u), Kasra (i)
          expect(romanizer.romanize('كَتَبَ'), equals('kataba'));
          expect(romanizer.romanize('كُتُب'), equals('kutub'));
        });

        test('should handle digraphs correctly', () {
          expect(romanizer.romanize('ث'), equals('th')); // Theh
          expect(romanizer.romanize('خ'), equals('kh')); // Khah
          expect(romanizer.romanize('ذ'), equals('dh')); // Thal
          expect(romanizer.romanize('ش'), equals('sh')); // Sheen
          expect(romanizer.romanize('غ'), equals('gh')); // Ghain
        });

        test('should handle numerals', () {
          expect(romanizer.romanize('١٢٣'), equals('123'));
          expect(romanizer.romanize('٠٩'), equals('09'));
        });

        test('should handle punctuation', () {
          // Arabic comma and question mark are not in the map, so they should pass through
          // unless explicitly mapped. Assuming default behavior acts as passthrough for unknowns.
          expect(
            romanizer.romanize('مرحبا، كيف حالك؟'),
            equals('mrḥbā، kyf ḥālk؟'),
          );
        });
      });

      group('DIN 31635', () {
        const romanizer = ArabicRomanizer(system: ArabicSystem.din31635);

        test('should use strict 1-to-1 mapping', () {
          expect(romanizer.romanize('شمس'), equals('šms')); // sheen -> š
          expect(romanizer.romanize('ثقب'), equals('ṯqb')); // theh -> ṯ
          expect(romanizer.romanize('جمال'), equals('ǧmāl')); // jeem -> ǧ
          expect(romanizer.romanize('خوخ'), equals('ḫwḫ')); // khah -> ḫ
        });

        test('should handle complex characters', () {
          // Dhad -> ḍ, Theh -> ṯ, Zah -> ẓ
          expect(romanizer.romanize('ض'), equals('ḍ'));
          expect(romanizer.romanize('ظ'), equals('ẓ'));
        });
      });

      group('Buckwalter', () {
        const romanizer = ArabicRomanizer(system: ArabicSystem.buckwalter);

        test('should use ASCII-only mapping', () {
          expect(romanizer.romanize('شمس'), equals('\$ms')); // sheen -> $
          expect(romanizer.romanize('ا'), equals('A')); // alif -> A
          expect(romanizer.romanize('ى'), equals('Y')); // alif maksura -> Y
          expect(romanizer.romanize('ة'), equals('p')); // teh marbuta -> p
        });

        test('should handle Hamza forms', () {
          expect(romanizer.romanize('أ'), equals('>')); // Alif with Hamza above
          expect(romanizer.romanize('إ'), equals('<')); // Alif with Hamza below
          expect(romanizer.romanize('ؤ'), equals('&')); // Waw with Hamza
          expect(romanizer.romanize('ئ'), equals('}')); // Yeh with Hamza
        });
      });

      group('Edge Cases', () {
        const romanizer = ArabicRomanizer();

        test('should handle empty string', () {
          expect(romanizer.romanize(''), isEmpty);
        });

        test('should preserve non-Arabic text', () {
          expect(romanizer.romanize('Hello ١٢٣'), equals('Hello 123'));
        });

        test('should handle mixed numerals and text', () {
          // "Year 2023"
          expect(romanizer.romanize('سنة ٢٠٢٣'), equals('snh 2023'));
        });

        test('should handle whitespace', () {
          expect(romanizer.romanize('   '), equals('   '));
        });
      });
    });
  });
}
