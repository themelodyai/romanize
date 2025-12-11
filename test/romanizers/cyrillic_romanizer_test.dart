import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  group('CyrillicRomanizer', () {
    const romanizer = CyrillicRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language, equals('cyrillic'));
    });

    group('isValid', () {
      test('should return true for Russian text', () {
        expect(romanizer.isValid('Привет'), isTrue);
        expect(romanizer.isValid('Здравствуй'), isTrue);
        expect(romanizer.isValid('Мир'), isTrue);
      });

      test('should return true for Ukrainian text', () {
        expect(romanizer.isValid('Привіт'), isTrue);
        expect(romanizer.isValid('Ґудзик'), isTrue);
      });

      test('should return true for Serbian text', () {
        expect(romanizer.isValid('Ђаво'), isTrue);
        expect(romanizer.isValid('Љубав'), isTrue);
      });

      test('should return false for non-Cyrillic text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse);
        expect(romanizer.isValid('안녕하세요'), isFalse);
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Cyrillic and other text', () {
        expect(romanizer.isValid('Привет Hello'), isTrue);
        expect(romanizer.isValid('Hello Привет'), isTrue);
      });

      test('should return false for empty string', () {
        expect(romanizer.isValid(''), isFalse);
      });

      test('should return false for whitespace-only string', () {
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize Russian text', () {
        final result = romanizer.romanize('Привет');
        expect(result, equals('Privet'));
      });

      test('should romanize "Привет мир" correctly', () {
        final result = romanizer.romanize('Привет мир');
        expect(result, contains('Privet'));
        expect(result, contains('mir'));
      });

      test('should romanize Ukrainian characters', () {
        expect(romanizer.romanize('Ґ'), equals('G'));
        expect(romanizer.romanize('Є'), equals('Ye'));
        expect(romanizer.romanize('І'), equals('I'));
        expect(romanizer.romanize('Ї'), equals('Yi'));
      });

      test('should romanize Serbian characters', () {
        expect(romanizer.romanize('Ђ'), equals('Dj'));
        expect(romanizer.romanize('Љ'), equals('Lj'));
        expect(romanizer.romanize('Њ'), equals('Nj'));
        expect(romanizer.romanize('Џ'), equals('Dz'));
      });

      test('should handle hard and soft signs', () {
        // Hard sign (Ъ) and soft sign (Ь) are usually omitted
        final result = romanizer.romanize('объект');
        expect(result, isNotEmpty);
      });

      test('should handle mixed content', () {
        final result = romanizer.romanize('Привет Hello');
        expect(result, contains('Privet'));
        expect(result, contains('Hello'));
      });

      test('should handle empty string', () {
        final result = romanizer.romanize('');
        expect(result, isEmpty);
      });

      test('should preserve non-Cyrillic characters', () {
        final result = romanizer.romanize('Привет Hello 123');
        expect(result, contains('Privet'));
        expect(result, contains('Hello'));
        expect(result, contains('123'));
      });

      test('should handle all Russian alphabet letters', () {
        const russianAlphabet = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';
        final result = romanizer.romanize(russianAlphabet);
        expect(result, isNotEmpty);
        expect(result.length, greaterThan(0));
      });

      test('should handle lowercase letters', () {
        const lowercase = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя';
        final result = romanizer.romanize(lowercase);
        expect(result, isNotEmpty);
        expect(result, equals(result.toLowerCase()));
      });
    });
  });
}

