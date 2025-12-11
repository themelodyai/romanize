import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  group('ArabicRomanizer', () {
    const romanizer = ArabicRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language, equals('arabic'));
    });

    group('isValid', () {
      test('should return true for Arabic text', () {
        expect(romanizer.isValid('أنا'), isTrue);
        expect(romanizer.isValid('العربي'), isTrue);
        expect(romanizer.isValid('ولد الغابة'), isTrue);
      });

      test('should return false for non-Arabic text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse);
        expect(romanizer.isValid('안녕하세요'), isFalse);
        expect(romanizer.isValid('Привет'), isFalse);
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Arabic and other text', () {
        expect(romanizer.isValid('أنا Hello'), isTrue);
        expect(romanizer.isValid('Hello أنا'), isTrue);
      });

      test('should return false for empty string', () {
        expect(romanizer.isValid(''), isFalse);
      });

      test('should return false for whitespace-only string', () {
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize Arabic text', () {
        final result = romanizer.romanize('أنا');
        expect(result, isNotEmpty);
        expect(result, isA<String>());
        expect(result, equals('ana'));
      });

      test('should handle mixed content', () {
        final result = romanizer.romanize('أنا Hello');
        expect(result, isNotEmpty);
        expect(result, equals('ana Hello'));
      });

      test('should handle empty string', () {
        final result = romanizer.romanize('');
        expect(result, isEmpty);
        expect(result, equals(''));
      });

      test('should preserve non-Arabic characters', () {
        final result = romanizer.romanize('أنا Hello 123');
        expect(result, contains('Hello'));
        expect(result, contains('123'));
        expect(result, equals('ana Hello 123'));
      });

      test('should handle longer Arabic text', () {
        const arabicText = 'أنا العربي ولد الغابة';
        final result = romanizer.romanize(arabicText);
        expect(result, isNotEmpty);
        expect(result, isA<String>());
        // ana al arabi wlad al ghaba
        expect(result, equals('ana alʿrby wld alghabh'));
      });
    });
  });
}
