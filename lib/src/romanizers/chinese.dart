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
    return PinyinHelper.getPinyin(
      input,
      separator: ' ',
      format: switch (toneAnnotation) {
        ToneAnnotation.none => PinyinFormat.WITHOUT_TONE,
        ToneAnnotation.number => PinyinFormat.WITH_TONE_NUMBER,
        ToneAnnotation.mark => PinyinFormat.WITH_TONE_MARK,
      },
    );
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
    // Check for Chinese characters in Unicode ranges:
    // - CJK Unified Ideographs: U+4E00–U+9FFF
    // - CJK Unified Ideographs Extension A: U+3400–U+4DBF
    // - CJK Unified Ideographs Extension B: U+20000–U+2A6DF
    // - CJK Unified Ideographs Extension C: U+2A700–U+2B73F
    // - CJK Unified Ideographs Extension D: U+2B740–U+2B81F
    // - CJK Unified Ideographs Extension E: U+2B820–U+2CEAF
    // - CJK Compatibility Ideographs: U+F900–U+FAFF
    // - CJK Radicals Supplement: U+2E80–U+2EFF
    // - CJK Strokes: U+31C0–U+31EF
    // - Ideographic Description Characters: U+2FF0–U+2FFF
    return RegExp(
      r'[\u4E00-\u9FFF\u3400-\u4DBF\uF900-\uFAFF\u2E80-\u2EFF\u31C0-\u31EF\u2FF0-\u2FFF]',
    ).hasMatch(input);
  }
}
