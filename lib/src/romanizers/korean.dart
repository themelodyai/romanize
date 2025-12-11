import 'package:korean_romanization_converter/korean_romanization_converter.dart';
import 'package:romanize/romanize.dart';

class KoreanRomanizer extends Romanizer {
  const KoreanRomanizer() : super(language: 'korean');

  static final _koreanRomanizationConverter = KoreanRomanizationConverter();
  static final _disassemble = Disassemble();
  static final _koreanPattern = RegExp(r'[\uAC00-\uD7AF]');

  /// Converts a given Korean string to its Romanized form.
  ///
  /// This method uses the `korean_romanization_converter` package to
  /// transliterate Korean characters into their Romanized equivalents.
  @override
  String romanize(String input) {
    final buffer = StringBuffer();
    for (final char in input.runes) {
      final charString = String.fromCharCode(char);
      buffer.write(
        _koreanRomanizationConverter.romanizeChar(
          _disassemble.disassembleChar(charString),
        ),
      );
    }
    return buffer.toString();
  }

  /// Validates if the input string is a valid Korean string.
  @override
  bool isValid(String input) {
    return _koreanPattern.hasMatch(input);
  }
}
