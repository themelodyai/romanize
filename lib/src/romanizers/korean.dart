import 'package:korean_romanization_converter/korean_romanization_converter.dart';
import 'package:romanize/romanize.dart';

class KoreanRomanizer extends Romanizer {
  const KoreanRomanizer() : super(language: 'korean');

  /// Converts a given Korean string to its Romanized form.
  ///
  /// This method uses the `korean_romanization_converter` package to
  /// transliterate Korean characters into their Romanized equivalents.
  @override
  String romanize(String input) {
    final converter = KoreanRomanizationConverter();
    return converter.romanize(input);
  }

  /// Validates if the input string is a valid Korean string.
  @override
  bool isValid(String input) {
    // A simple check to see if the string contains Hangul characters.
    return RegExp(r'[\uAC00-\uD7AF]').hasMatch(input);
  }
}
