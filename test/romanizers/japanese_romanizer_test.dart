import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  group('JapaneseRomanizer', () {
    const romanizer = JapaneseRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language, equals('japanese'));
    });

    group('isValid', () {
      test('should return true for Japanese text', () {
        expect(romanizer.isValid('こんにちは'), isTrue);
        expect(romanizer.isValid('苦しい'), isTrue);
        expect(romanizer.isValid('どっちが you smart'), isTrue);
      });

      test('should return false for non-Japanese text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('안녕하세요'), isFalse);
        expect(romanizer.isValid('Привет'), isFalse);
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Japanese and other text', () {
        expect(romanizer.isValid('こんにちは Hello'), isTrue);
        expect(romanizer.isValid('Hello こんにちは'), isTrue);
      });

      test('should return false for empty string', () {
        expect(romanizer.isValid(''), isFalse);
      });

      test('should return false for whitespace-only string', () {
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize Japanese text', () {
        final result = romanizer.romanize('こんにちは');
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      });

      test('should handle mixed content', () {
        final result = romanizer.romanize('こんにちは Hello');
        expect(result, isNotEmpty);
      });

      test('should handle empty string', () {
        final result = romanizer.romanize('');
        expect(result, isEmpty);
      });

      test('should preserve non-Japanese characters', () {
        final result = romanizer.romanize('こんにちは Hello 123');
        expect(result, contains('Hello'));
        expect(result, contains('123'));
      });
    });
  });
}
