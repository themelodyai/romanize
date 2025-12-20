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

  String _convertToPinyin(String input) {
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

    if (!input.contains('\n')) {
      return _convertToPinyin(input);
    }

    final buffer = StringBuffer();
    final lines = input.split('\n');
    for (final line in lines) {
      buffer.writeln(_convertToPinyin(line));
    }
    return buffer.toString();
  }

  static final _kanaPattern = RegExp(r'[\u3040-\u309F\u30A0-\u30FF]');

  /// Validates if the input string contains Chinese characters.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ChineseRomanizer();
  /// print(romanizer.isValid('你好')); // true
  /// print(romanizer.isValid('Hello')); // false
  /// print(romanizer.isValid('你好 Hello')); // true (mixed content)
  /// ```
  ///
  /// Returns `true` if the input contains Chinese characters AND does not
  /// contain Japanese Kana. This helps avoid falsely identifying mixed
  /// Japanese text (Kanji + Kana) as Chinese.
  @override
  bool isValid(String input) {
    // If it contains Kana (Hiragana/Katakana), it is likely Japanese,
    // even if it also contains Kanji (which containsChinese checks for).
    if (_kanaPattern.hasMatch(input)) {
      return false;
    }

    return ChineseHelper.containsChinese(input);
  }
}
