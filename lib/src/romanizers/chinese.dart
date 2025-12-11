import 'package:pinyin/pinyin.dart';
import 'package:romanize/romanize.dart';

/// The tone annotation to use for the Pinyin romanization.
enum ToneAnnotation {
  /// No tone annotation.
  none,

  /// The tone annotation as a number.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ChineseRomanizer(toneAnnotation: ToneAnnotation.number);
  /// print(romanizer.romanize('你好')); // i3 hao3
  /// ```
  number,

  /// The tone annotation as a mark.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ChineseRomanizer(toneAnnotation: ToneAnnotation.mark);
  /// print(romanizer.romanize('你好')); // nǐ hǎo
  /// ```
  mark,
}

/// A romanizer for Chinese script (Simplified and Traditional).
///
/// Supports transliteration of Chinese characters into Pinyin using
/// the `pinyin` package. Pinyin is the standard romanization system
/// for Mandarin Chinese.
class ChineseRomanizer extends Romanizer {
  const ChineseRomanizer({this.toneAnnotation = ToneAnnotation.mark})
    : super(language: 'chinese');

  final ToneAnnotation toneAnnotation;

  /// Converts a given Chinese string to its Romanized form (Pinyin).
  ///
  /// This method uses the `pinyin` package to transliterate Chinese
  /// characters into their Pinyin equivalents. Tones are omitted for
  /// better readability in karaoke and general use.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ChineseRomanizer();
  /// final result = romanizer.romanize('你好');
  /// print(result); // ni hao
  /// ```
  @override
  String romanize(String input) {
    if (input.trim().isEmpty) return '';

    final buffer = StringBuffer();
    final lines = input.split('\n');
    for (final line in lines) {
      final words = line.split(' ');
      for (final word in words) {
        buffer.write(
          PinyinHelper.getPinyin(
            word,
            separator: ' ',
            format: switch (toneAnnotation) {
              ToneAnnotation.none => PinyinFormat.WITHOUT_TONE,
              ToneAnnotation.number => PinyinFormat.WITH_TONE_NUMBER,
              ToneAnnotation.mark => PinyinFormat.WITH_TONE_MARK,
            },
          ),
        );
        buffer.write(' ');
      }
      if (lines.length > 1) buffer.write('\n');
    }
    return buffer.toString();
  }

  /// Validates if the input string contains Chinese characters.
  ///
  /// Returns `true` if the input contains any Chinese characters from
  /// the Unicode CJK (Chinese, Japanese, Korean) blocks. Note that this
  /// will also match Japanese Kanji and Korean Hanja, but the romanization
  /// will use Pinyin pronunciation.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ChineseRomanizer();
  /// print(romanizer.isValid('你好')); // true
  /// print(romanizer.isValid('Hello')); // false
  /// print(romanizer.isValid('你好 Hello')); // true (mixed content)
  /// ```
  @override
  bool isValid(String input) {
    return ChineseHelper.containsChinese(input);
  }
}
