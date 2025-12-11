import 'package:arabic_roman_conv/arabic_roman_conv.dart';
import 'package:romanize/romanize.dart';

/// A romanizer for Arabic script.
///
/// Supports transliteration of Arabic characters into Latin script using
/// the `arabic_roman_conv` package.
class ArabicRomanizer extends Romanizer {
  const ArabicRomanizer() : super(language: 'arabic');

  static final converter = ArabicRomanConv();

  /// Converts a given Arabic string to its Romanized form.
  ///
  /// This method uses the `arabic_roman_conv` package to transliterate
  /// Arabic characters into their Latin equivalents.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ArabicRomanizer();
  /// final result = romanizer.romanize('أنا العربي');
  /// print(result); // ana al'arabi
  /// ```
  @override
  String romanize(String input) {
    return converter.romanized(input);
  }

  /// Validates if the input string contains Arabic characters.
  ///
  /// Returns `true` if the input contains any Arabic characters from
  /// the Unicode Arabic blocks.
  ///
  /// Example:
  /// ```dart
  /// final romanizer = ArabicRomanizer();
  /// print(romanizer.isValid('أنا')); // true
  /// print(romanizer.isValid('Hello')); // false
  /// print(romanizer.isValid('أنا Hello')); // true (mixed content)
  /// ```
  @override
  bool isValid(String input) {
    // Check for Arabic characters in Unicode ranges:
    // - Arabic: U+0600–U+06FF
    // - Arabic Supplement: U+0750–U+077F
    // - Arabic Extended-A: U+08A0–U+08FF
    // - Arabic Extended-B: U+0870–U+089F
    // - Arabic Presentation Forms-A: U+FB50–U+FDFF
    // - Arabic Presentation Forms-B: U+FE70–U+FEFF
    return RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u0870-\u089F\uFB50-\uFDFF\uFE70-\uFEFF]',
    ).hasMatch(input);
  }
}
