import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  group('KoreanRomanizer', () {
    const romanizer = KoreanRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language, equals('korean'));
    });

    group('isValid', () {
      test('should return true for Korean text', () {
        expect(romanizer.isValid('안녕하세요'), isTrue);
        expect(romanizer.isValid('한국어'), isTrue);
        expect(romanizer.isValid('천사 같은 "Hi"'), isTrue);
      });

      test('should return false for non-Korean text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse);
        expect(romanizer.isValid('Привет'), isFalse);
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Korean and other text', () {
        expect(romanizer.isValid('안녕 Hello'), isTrue);
        expect(romanizer.isValid('Hello 안녕'), isTrue);
      });

      test('should return false for empty string', () {
        expect(romanizer.isValid(''), isFalse);
      });

      test('should return false for whitespace-only string', () {
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize Korean text', () {
        final result = romanizer.romanize('안녕하세요');
        expect(result, isNotEmpty);
        expect(result, isA<String>());
        expect(result, equals('annyeonghaseyo'));
      });

      test('should handle mixed content', () {
        final result = romanizer.romanize('안녕 Hello');
        expect(result, isNotEmpty);
        expect(result, equals('annyeong Hello'));
      });

      test('should handle empty string', () {
        final result = romanizer.romanize('');
        expect(result, isEmpty);
      });

      test('should preserve non-Korean characters', () {
        final result = romanizer.romanize('안녕 Hello 123');
        expect(result, contains('Hello'));
        expect(result, contains('123'));
        expect(result, equals('annyeong Hello 123'));
      });
    });
  });
}
