import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    await TextRomanizer.ensureInitialized();
  });

  group('DevanagariRomanizer', () {
    const romanizer = DevanagariRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language.name, equals('devanagari'));
    });

    group('isValid', () {
      test('should return true for Hindi text', () {
        expect(romanizer.isValid('नमस्ते'), isTrue);
        expect(romanizer.isValid('भारत'), isTrue);
        expect(romanizer.isValid('हिन्दी'), isTrue);
      });

      test('should return false for non-Devanagari text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse);
        expect(romanizer.isValid('안녕하세요'), isFalse);
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Devanagari and other text', () {
        expect(romanizer.isValid('नमस्ते Hello'), isTrue);
        expect(romanizer.isValid('Hello नमस्ते'), isTrue);
      });

      test('should return false for empty string', () {
        expect(romanizer.isValid(''), isFalse);
      });

      test('should return false for whitespace-only string', () {
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize common Hindi words', () {
        expect(romanizer.romanize('नमस्ते'), equals('namaste'));
        expect(romanizer.romanize('भारत'), equals('bhārata'));
        expect(romanizer.romanize('हिन्दी'), equals('hindī'));
        expect(romanizer.romanize('स्वागत'), equals('svāgata'));
      });

      test('should romanize independent vowels', () {
        expect(romanizer.romanize('अआइईउऊएऐओऔ'), equals('aāiīuūeaioau'));
      });

      test('should handle the inherent vowel and virama', () {
        expect(romanizer.romanize('क'), equals('ka'));
        expect(romanizer.romanize('क्'), equals('k'));
        expect(romanizer.romanize('का'), equals('kā'));
        expect(romanizer.romanize('कि'), equals('ki'));
      });

      test('should romanize conjuncts', () {
        expect(romanizer.romanize('क्क'), equals('kka'));
        expect(romanizer.romanize('क्ष'), equals('kṣa'));
        expect(romanizer.romanize('त्र'), equals('tra'));
        expect(romanizer.romanize('ज्ञ'), equals('jña'));
      });

      test('should romanize anusvara and visarga', () {
        expect(romanizer.romanize('अं'), equals('aṃ'));
        expect(romanizer.romanize('अः'), equals('aḥ'));
      });

      test('should romanize nukta consonants', () {
        expect(romanizer.romanize('ज़'), equals('za'));
        expect(romanizer.romanize('ड़'), equals('ṛa'));
        expect(romanizer.romanize('फ़'), equals('fa'));
        expect(romanizer.romanize('ख़'), equals('xa'));
      });

      test('should romanize Devanagari digits', () {
        expect(romanizer.romanize('१२३'), equals('123'));
      });

      test('should handle mixed content', () {
        expect(
          romanizer.romanize('नमस्ते Hello 123'),
          equals('namaste Hello 123'),
        );
      });

      test('should handle empty string', () {
        expect(romanizer.romanize(''), isEmpty);
      });
    });

    group('DevanagariSystem.ascii', () {
      const ascii = DevanagariRomanizer(system: DevanagariSystem.ascii);

      test('should produce plain ASCII without diacritics', () {
        expect(ascii.romanize('भारत'), equals('bhaarata'));
        expect(ascii.romanize('हिन्दी'), equals('hindii'));
        expect(ascii.romanize('शिव'), equals('shiva'));
      });

      test('should keep short vowels and consonants unchanged', () {
        expect(ascii.romanize('नमस्ते'), equals('namaste'));
      });

      test('should romanize marks to ASCII', () {
        expect(ascii.romanize('अं'), equals('an'));
        expect(ascii.romanize('अः'), equals('ah'));
      });

      test('should romanize nukta consonants to ASCII', () {
        expect(ascii.romanize('ज़'), equals('za'));
        expect(ascii.romanize('ड़'), equals('ra'));
        expect(ascii.romanize('फ़'), equals('fa'));
      });
    });
  });
}
