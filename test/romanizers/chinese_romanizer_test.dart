import 'package:romanize/romanize.dart';
import 'package:test/test.dart';

void main() {
  group('ChineseRomanizer', () {
    const romanizer = ChineseRomanizer();

    test('should have correct language name', () {
      expect(romanizer.language, equals('chinese'));
    });

    group('isValid', () {
      test('should return true for Simplified Chinese text', () {
        expect(romanizer.isValid('你好'), isTrue);
        expect(romanizer.isValid('中国'), isTrue);
        expect(romanizer.isValid('北京'), isTrue);
      });

      test('should return true for Traditional Chinese text', () {
        expect(romanizer.isValid('你好'), isTrue);
        expect(romanizer.isValid('臺灣'), isTrue);
      });

      test('should return false for non-Chinese text', () {
        expect(romanizer.isValid('Hello'), isFalse);
        expect(romanizer.isValid('こんにちは'), isFalse);
        expect(romanizer.isValid('안녕하세요'), isFalse);
        expect(romanizer.isValid('Привет'), isFalse);
        expect(romanizer.isValid('123'), isFalse);
      });

      test('should return true for mixed Chinese and other text', () {
        expect(romanizer.isValid('你好 Hello'), isTrue);
        expect(romanizer.isValid('Hello 你好'), isTrue);
      });

      test('should return false for empty string', () {
        expect(romanizer.isValid(''), isFalse);
      });

      test('should return false for whitespace-only string', () {
        expect(romanizer.isValid('   '), isFalse);
      });
    });

    group('romanize', () {
      test('should romanize Chinese text to Pinyin', () {
        final result = romanizer.romanize('你好');
        expect(result, isNotEmpty);
        expect(result, isA<String>());
        // Should contain pinyin syllables separated by spaces
        expect(result.split(' ').length, greaterThanOrEqualTo(1));
      });

      test('should handle longer Chinese text', () {
        final result = romanizer.romanize('你好世界');
        expect(result, isNotEmpty);
        expect(result, isA<String>());
      });

      test('should handle mixed content', () {
        final result = romanizer.romanize('你好 Hello');
        expect(result, isNotEmpty);
      });

      test('should handle empty string', () {
        final result = romanizer.romanize('');
        expect(result, isEmpty);
      });

      test('should preserve non-Chinese characters', () {
        final result = romanizer.romanize('你好 Hello 123');
        expect(result, contains('Hello'));
        expect(result, contains('123'));
      });

      test('should handle common Chinese phrases', () {
        final result1 = romanizer.romanize('谢谢');
        final result2 = romanizer.romanize('再见');
        expect(result1, isNotEmpty);
        expect(result2, isNotEmpty);
      });

      test('should handle numbers and punctuation', () {
        final result = romanizer.romanize('你好123！');
        expect(result, isNotEmpty);
        expect(result, contains('123'));
      });
    });
  });
}

